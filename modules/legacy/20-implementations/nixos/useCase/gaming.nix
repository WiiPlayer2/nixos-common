{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.useCase.gaming;
in
{
  config = mkMerge [
    (mkIf cfg.enable {
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
      '';
    })
    (mkIf cfg.cloud-gaming.enable {
      services.sunshine = {
        enable = true;
        openFirewall = true;
        capSysAdmin = true;
        package = pkgs.unstable.sunshine;
      };
    })
  ];
}
