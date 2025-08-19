{ config, pkgs, lib, ... }:
{
  services.power-profiles-daemon.enable = lib.mkIf config.services.tlp.enable (false);

  virtualisation = {
    useEFIBoot = true;
    qemu = {
      options = [
        "-vga qxl"
        "-display spice-app"
        "-device virtio-serial-pci"
        "-spice unix=on,addr=/tmp/nixosvm_${config.networking.hostName}_spice.socket,disable-ticketing=on"
        "-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
        "-chardev spicevmc,id=spicechannel0,name=vdagent"
      ];
    };
  };

  users.users = {
    root = {
      password = "vm";
      initialHashedPassword = lib.mkForce null;
    };
    ${config.my.config.mainUser.name} = {
      password = "vm";
      initialHashedPassword = lib.mkForce null;
    };
  };
}
