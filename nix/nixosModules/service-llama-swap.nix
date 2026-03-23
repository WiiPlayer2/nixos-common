_:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.llama-swap.llama-server;
  modelConfigModule = {
    options = {
      contextSize = mkOption {
        type = with types; nullOr int;
        default = null;
      };

      ttl = mkOption {
        type = with types; nullOr int;
        default = null;
      };
    };
  };
in
{
  options.services.llama-swap = {
    llama-server = {
      package = mkPackageOption pkgs "llama-cpp" { };
      defaults = mkOption {
        type = types.submodule modelConfigModule;
        default = { };
      };
      models = mkOption {
        type = types.attrsOf (
          types.submodule (
            { config, ... }:
            {
              imports = [
                modelConfigModule
              ];

              options = {
                id = mkOption {
                  type = types.str;
                  default = config._module.args.name;
                };

                filePath = mkOption {
                  type = types.path;
                };
              };

              config = {
                contextSize = mkDefault cfg.defaults.contextSize;
                ttl = mkDefault cfg.defaults.ttl;
              };
            }
          )
        );
        default = { };
      };
    };
  };

  config = mkIf config.services.llama-swap.enable {
    services.llama-swap.settings.models =
      let
        llama-server-models = mapAttrs' (_: v: {
          name = v.id;
          value = {
            env = [
              "HOME=/tmp"
            ];
            cmd = ''
              ${getExe' cfg.package "llama-server"} \
                --port ''${PORT} \
                ${escapeShellArgs (
                  [
                    "-m"
                    v.filePath
                    "--no-warmup"
                    "--parallel"
                    "1"
                    "--gpu-layers"
                    "all"
                    "--jinja"
                  ]
                  ++ optionals (v.contextSize != null) [
                    "--ctx-size"
                    (toString v.contextSize)
                  ]
                )}
            '';
          }
          // optionalAttrs (v.ttl != null) {
            inherit (v) ttl;
          };
        }) cfg.models;
      in
      llama-server-models;
  };
}
