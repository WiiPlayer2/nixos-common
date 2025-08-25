{ lib, config, ... }:
with lib;
let
  cfg = config.my.machine;
in
{
  options.my.machine = {
    devices = {
      displayBacklight.enable = mkEnableOption "Whether the machine has a display backlight";
      battery.enable = mkEnableOption "Whether the machine has a battery";
      fingerprint.enable = mkEnableOption "Whether the machine has a fingerprint sensor";
    };
  };

  config = mkMerge [
    (mkIf cfg.devices.fingerprint.enable {
      my.features.fingerprint.enable = true;
    })
  ];
}
