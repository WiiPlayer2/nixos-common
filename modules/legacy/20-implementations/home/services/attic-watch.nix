{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.services.attic-watch;
in
{
  # TODO: https://haseebmajid.dev/posts/2023-10-08-how-to-create-systemd-services-in-nix-home-manager/
  config = mkIf cfg.enable {
    systemd.user.services.attic-watch = {
      Unit = {
        Description = "A service running attic watch-store";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.attic-client}/bin/attic watch-store default";
        RestartSec = "1s";
        RestartSteps = 10;
        RestartMaxDelaySec = "5min";
        Restart = "always";
      };
    };
  };
}
