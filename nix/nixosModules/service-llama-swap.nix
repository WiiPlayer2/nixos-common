_:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg' = config.services.llama-swap;
  cfg = cfg'.llama-server;
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

      commandPrefix = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      additionalArgs = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      dynamicPort = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
in
{
  options.services.llama-swap = {
    user = mkOption {
      type = with types; nullOr str;
      default = null;
    };
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
                  type = with types; nullOr path;
                  default = null;
                };

                repo = mkOption {
                  type = with types; nullOr str;
                  default = null;
                };

                quant = mkOption {
                  type = with types; nullOr str;
                  default = null;
                };

                aliases = mkOption {
                  type = with types; listOf str;
                  default = [ ];
                };
              };

              config = {
                contextSize = mkDefault cfg.defaults.contextSize;
                ttl = mkDefault cfg.defaults.ttl;
                commandPrefix = mkDefault cfg.defaults.commandPrefix;
                additionalArgs = mkDefault cfg.defaults.additionalArgs;
                dynamicPort = mkDefault cfg.defaults.dynamicPort;
              };
            }
          )
        );
        default = { };
      };
    };
  };

  config = mkIf cfg'.enable {
    services.llama-swap.settings.models =
      let
        llama-server-models = mapAttrs' (_: v: {
          name = v.id;
          value = {
            # env = [
            #   "HOME=/tmp"
            # ];
            cmd = ''
              ${
                if v.commandPrefix == null then "" else "${v.commandPrefix} "
              }${getExe' cfg.package "llama-server"} \
                ${if v.dynamicPort then "--port \${PORT}" else ""} \
                ${escapeShellArgs (
                  [
                    "--no-warmup"
                    "--parallel"
                    "1"
                    "--gpu-layers"
                    "all"
                    "--jinja"
                  ]
                  ++ optionals (v.filePath != null) [
                    "-m"
                    v.filePath
                  ]
                  ++ optionals (v.repo != null) [
                    "-hf"
                    (if v.quant == null then v.repo else "${v.repo}:${v.quant}")
                  ]
                  ++ optionals (v.contextSize != null) [
                    "--ctx-size"
                    (toString v.contextSize)
                  ]
                  ++ v.additionalArgs
                )}
            '';
          }
          // optionalAttrs (v.ttl != null) {
            inherit (v) ttl;
          };
        }) cfg.models;
      in
      llama-server-models;

    systemd.services.llama-swap = mkIf (cfg'.user != null) {
      serviceConfig = {
        User = cfg'.user;
        DynamicUser = mkForce false;
        ProtectHome = mkForce false;

        MemoryDenyWriteExecute = mkForce false; # for .NET (due to JIT)
      };
    };
  };
}
