{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.nixDir;

  load =
    loader: loaderName:
    let
      dirEntries = builtins.readDir (cfg.src + "/${loaderName}");
      nameFromEntry = removeSuffix ".nix";
      pathMap = listToAttrs (
        map (
          { name, value }:
          {
            name = nameFromEntry name;
            value = cfg.src + "/${loaderName}/${name}";
          }
        ) (attrsToList dirEntries)
      );
      loaded = loader pathMap;
    in
    loaded;
in
{
  options.nixDir = {
    src = mkOption {
      type = types.path;
      default = inputs.self + /nix;
    };

    loaders = mkOption {
      type = types.lazyAttrsOf (types.functionTo types.anything);
      default = { };
    };
  };

  config = {
    nixDir.loaders = {
      nixosModules = mapAttrs (_: p: setDefaultModuleLocation p (import p inputs));
    };

    flake = mapAttrs (n: v: load v n) cfg.loaders;
  };
}
