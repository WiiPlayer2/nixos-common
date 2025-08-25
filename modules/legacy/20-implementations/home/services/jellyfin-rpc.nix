{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.services.jellyfin-rpc;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jellyfin-rpc
    ];

    # TODO: configure jellyfin-rpc

    systemd.user.services.jellyfin-rpc = {
      Unit = {
        Description = "A service running jellyfin-rpc";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.jellyfin-rpc}/bin/jellyfin-rpc";
        RestartSec = "1s";
        RestartSteps = 10;
        RestartMaxDelaySec = "5min";
        Restart = "always";
      };
    };
  };
}
