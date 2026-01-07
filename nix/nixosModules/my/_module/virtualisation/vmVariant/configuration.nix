{
  config,
  pkgs,
  lib,
  ...
}:
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
    memorySize = 2048;
  };

  users.users = {
    root = {
      password = lib.mkVMOverride "vm";
      initialHashedPassword = lib.mkVMOverride null;
    };
    ${config.my.config.mainUser.name} = {
      password = lib.mkVMOverride "vm";
      initialHashedPassword = lib.mkVMOverride null;
    };
  };
}
