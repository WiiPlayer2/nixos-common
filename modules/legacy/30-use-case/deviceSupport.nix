{ lib, config, ... }:
with lib;
let
  cfg = config.my.deviceSupport;
in
{
  options.my.deviceSupport = {
    rgbDevices = {
      enable = mkEnableOption "RGB devices";
    };
    tablets = {
      enable = mkEnableOption "Pen Tablet devices";
    };
  };

  config.my = mkMerge [
    (mkIf cfg.rgbDevices.enable {
      services.openrgb.enable = true;
    })
    (mkIf cfg.tablets.enable {
      services.opentabletdriver.enable = true;
    })
  ];
}
