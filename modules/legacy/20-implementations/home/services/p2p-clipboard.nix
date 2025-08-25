{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.services.p2p-clipboard;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      p2p-clipboard
    ];
    systemd.user.services.p2p-clipboard = {
      Unit = {
        Description = "A service running p2p-clipboard";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.p2p-clipboard}/bin/p2p-clipboard -l 0.0.0.0:${toString cfg.port} -p a33379d4-e4e2-5d77-b162-4e190f074a4b";
        RestartSec = "1s";
        RestartSteps = 10;
        RestartMaxDelaySec = "5min";
        Restart = "on-abnormal";
      };
    };
  };
}
