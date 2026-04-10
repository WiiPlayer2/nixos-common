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
              ${getExe' cfg.package "llama-server"} \
                --port ''${PORT} \
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
        # PrivateMounts = mkForce false;
        # PrivateTmp = mkForce false;
        # PrivateUsers = mkForce false;
        ProtectHome = mkForce false;
        DynamicUser = mkForce false;
        # ProtectHostname = mkForce false;
      };
    };
  };
}
