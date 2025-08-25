{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.vm-guest;
  isGraphical = config.my.features.graphical.enable;
in
{
  options.my.features = {
    vm-guest.enable = mkEnableOption "VM guest";
  };

  config.my = mkMerge [
    (mkIf cfg.enable {
      services = {
        qemuGuest.enable = true;
        spice-vdagentd.enable = true;
        # spice-webdavd.enable = true; # For hypervisor, needed for folder sharing in windows
      };
    })
    (mkIf (cfg.enable && isGraphical) {
      services = {
        spice-autorandr.enable = true;
      };
    })
  ];
}
