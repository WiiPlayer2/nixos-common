_:
{
  lib,
  config,
  pkgs,
  ...
}:
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
      default = 4090;
    };
    restartTriggers = mkOption {
      type = with types; listOf path;
      default = [ ];
    };
    path = mkOption {
      type = with types; listOf package;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    programs.opencode.enable = true;

    systemd.user = {
      # sockets.opencode = {
      #   Unit = {
      #     Description = "Socket for opencode web";
      #   };

      #   Socket = {
      #     ListenStream = "0.0.0.0:${toString cfg.port}";
      #   };

      #   Install = {
      #     WantedBy = [ "sockets.target" ];
      #   };
      # };
      services.opencode = {
        Unit = {
          Description = "opencode web";
          X-Restart-Triggers = [
            config.xdg.configFile."opencode/opencode.json".source
          ]
          ++ cfg.restartTriggers;
        };

        Service = {
          Type = "exec";
          Environment = [
            "DISPLAY=:0"
            "PATH=${makeBinPath cfg.path}"
          ];
          ExecStart = "${pkgs.runtimeShell} -lc ${escapeShellArg (
            "${getExe cfgP.package} serve ${
              escapeShellArgs ([
                "--hostname"
                "0.0.0.0"
                "--port"
                (toString cfg.port)
                "--print-logs"
              ])
            }"
          )}";
          Restart = "always";
          RestartSec = 5;
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
  };
}
