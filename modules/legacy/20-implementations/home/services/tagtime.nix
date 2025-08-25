{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.services.tagtime;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tagtime
    ];

    systemd.user.services.tagtime = {
      Unit = {
        Description = "A service running tagtime";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Environment = "DISPLAY=:0"; # always try to run on the primary display
        ExecStart = "${pkgs.tagtime}/bin/tagtimed";
        RestartSec = "1s";
        RestartSteps = 10;
        RestartMaxDelaySec = "5min";
        Restart = "on-abnormal";
      };
    };
  };
}
