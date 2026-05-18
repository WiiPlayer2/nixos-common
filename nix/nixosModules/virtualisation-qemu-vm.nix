# adapted from https://discourse.nixos.org/t/wayland-compositors-an-build-vm-not-working/46486/2
_:
{ config, ... }:
let
  MB = 1;
  GB = 1024 * MB;
in
{
  virtualisation = {
    useEFIBoot = true;
    qemu = {
      options = [
        "-device virtio-vga-gl"
        # "-display sdl,gl=on,show-cursor=off"
        "-display spice-app,gl=on,show-cursor=off"

        # Wire up pipewire audio
        "-audiodev pipewire,id=audio0"
        "-device intel-hda"
        "-device hda-output,audiodev=audio0"

        # SPICE
        "-device virtio-serial-pci"
        "-spice unix=on,addr=/tmp/nixosvm_${config.networking.hostName}_spice.socket,disable-ticketing=on"
        "-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
        "-chardev spicevmc,id=spicechannel0,name=vdagent"
      ];
    };
    cores = 4;
    memorySize = 4 * GB;
    diskSize = 10 * GB;
  };

  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
}
