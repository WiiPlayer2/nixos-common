_:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.llama-swap;
in
{
  options.services.llama-swap = {
    llama-server-package = mkPackageOption pkgs "llama-cpp" { };
    llama-server-models = mkOption {
      type = types.attrsOf (
        types.submodule (
          { config, ... }:
          {
            options = {
              id = mkOption {
                type = types.str;
                default = config._module.args.name;
              };

              filePath = mkOption {
                type = types.path;
              };

              contextSize = mkOption {
                type = types.int;
              };

              ttl = mkOption {
                type = with types; nullOr int;
                default = null;
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config = mkIf cfg.enable {
    services.llama-swap.settings.models =
      let
        llama-server-models = mapAttrs' (_: v: {
          name = v.id;
          value = {
            env = [
              "HOME=/tmp"
            ];
            cmd = ''
              ${getExe' cfg.llama-server-package "llama-server"} \
                --port ''${PORT} \
                -m ${escapeShellArg v.filePath} \
                --no-warmup \
                --parallel 1 \
                --gpu-layers 99 \
                --jinja \
                --ctx-size ${toString v.contextSize}
            '';
          }
          // optionalAttrs (v.ttl != null) {
            inherit (v) ttl;
          };
        }) cfg.llama-server-models;
      in
      llama-server-models;
  };
}
