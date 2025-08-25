{ lib, ... }:
with lib;
let
  services = [
    "attic-watch"
    "ftp"
    "gitea"
    "jellyfin-rpc"
    "monado"
    "mullvad"
    "openrgb"
    "opentabletdriver"
    "qemuGuest"
    "samba"
    "softether-vpn-server"
    "spice-autorandr"
    "spice-vdagentd"
    "ssh"
    "swapspace"
    "tagtime"
  ];
  mkServiceOption = description: {
    enable = mkEnableOption description;
  };
  serviceOptions = listToAttrs (
    map
      (x: {
        name = x;
        value = mkServiceOption x;
      })
      services
  );
in
{
  options.my.services = serviceOptions;
}
