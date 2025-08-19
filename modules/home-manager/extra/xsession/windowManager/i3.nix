{ lib, config, ... }:
with lib;
let
  cfg = config.xsession.windowManager.i3;
in
{
  options.xsession.windowManager.i3 = {
    enableSystemdTarget = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    xsession.windowManager.i3.config.startup = [
      {
        command = "systemctl --user start i3-session.target";
        notification = false;
      }
    ];

    systemd.user.targets.i3-session = mkIf cfg.enableSystemdTarget {
      Unit = {
        Description = "i3 session target";
        Requires = [
          "graphical-session.target"
        ];
        After = [
          "graphical-session.target"
        ];
      };
    };
  };
}
