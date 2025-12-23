_:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.security.cmd-polkit;

  serviceScript = pkgs.writeShellApplication {
    name = "polkit-cmd-polkit";
    text = ''
      exec ${getExe cfg.package} ${
        if cfg.mode == "serial" then "--serial" else "--parallel"
      } --command ${escapeShellArg cfg.command}
    '';
  };
in
{
  options.security.cmd-polkit = {
    enable = mkEnableOption "";
    package = mkPackageOption pkgs "cmd-polkit" { };
    mode = mkOption {
      type = types.enum [
        "serial"
        "parallel"
      ];
    };
    command = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.polkit-cmd-polkit = {
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      script = getExe serviceScript;
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
