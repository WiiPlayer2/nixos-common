{ lib, config, ... }:
with lib;
let
  getEntriesForPath =
    path:
    mapAttrs
      (
        name: value:
        let
          fullPath = path + "/${name}";
        in
        if value == "directory" then getEntriesForPath fullPath else fullPath
      )
      (builtins.readDir path);

  cfg = config.my.assets;
in
{
  # TODO: might not be the correct place in 40-domain
  options.my.assets = {
    root = mkOption {
      type = types.path;
    };
    files = mkOption {
      description = "The asset files";
      type = types.raw;
    };
  };

  config.my.assets = {
    files = getEntriesForPath cfg.root;
  };
}
