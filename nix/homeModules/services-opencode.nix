_:
{ lib, config, ... }:
with lib;
let
  cfg = config.services.opencode;
  cfgP = config.programs.opencode;
in
{
  options.services.opencode = {
    enable = mkEnableOption "";
    port = mkOption {
      type = types.port;
      default = 4096;
    };
    restartTriggers = mkOption {
      type = with types; listOf path;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    programs.opencode.enable = true;

    systemd.user = {
      sockets.opencode = {
        Unit = {
          Description = "Socket for opencode web";
        };

        Socket = {
          ListenStream = "0.0.0.0:4096";
        };

        Install = {
          WantedBy = [ "sockets.target" ];
        };
      };
      services.opencode = {
        Unit = {
          Description = "opencode web";
          X-Restart-Triggers = [
            config.xdg.configFile."opencode/config.json".source
          ]
          ++ cfg.restartTriggers;
        };

        Service = {
          Type = "exec";
          ExecStart = "${getExe cfgP.package} serve ${
            escapeShellArgs ([
              "--hostname"
              "0.0.0.0"
              "--port"
              (toString cfg.port)
            ])
          }";
          Restart = "always";
          RestartSec = 5;
        };
      };
    };
  };
}
