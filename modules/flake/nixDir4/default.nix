{
  lib,
  config,
  inputs,
  withSystem,
  ...
}:
with lib;
let
  cfg = config.nixDir4;
  nixDirLib = cfg.lib;

  first = ls: elemAt ls 0;
in
{
  imports = [
    ./loaders
  ];

  options.nixDir4 = {
    lib = mkOption {
      type = types.raw;
      readOnly = true;
      default = inputs.haumea.lib.load {
        src = ./lib;
        inputs = {
          inherit config inputs withSystem;
          lib = extend (_: _: inputs.haumea.lib);
        };
      };
    };

    root = mkOption {
      type = types.path;
    };

    src = mkOption {
      type = types.path;
      default = cfg.root + /nix4;
    };

    loaders = mkOption {
      type = types.submoduleWith {
        modules = [
          {
            freeformType = types.lazyAttrsOf nixDirLib.types.loader;
            # options = {
            #   perSystem = mkOption {
            #     type = types.lazyAttrsOf nixDirLib.types.perSystemLoader;
            #     default = { };
            #   };
            # };
          }
        ];
      };
      default = { };
    };
  };

  config.flake =
    let
      loaderPathResult =
        loadCfg: path:
        let
          loadResult = loadCfg.loader path;
        in
        {
          ${loadCfg.target} = loadResult;
        };

      loaderResult = loadCfg: mergeAttrsList (map (loaderPathResult loadCfg) loadCfg.paths);

      result = mergeAttrsList (
        map loaderResult (
          # (attrValues (removeAttrs cfg.loaders [ "perSystem" ])) ++ (attrValues cfg.loaders.perSystem)
          (attrValues (removeAttrs cfg.loaders [ "perSystem" ]))
        )
      );
    in
    result;
}
