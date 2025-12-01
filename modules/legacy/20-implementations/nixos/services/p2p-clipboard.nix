{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.services.p2p-clipboard;
in
{
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      cfg.port
    ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
  };
}
