{ lib, ... }:
with lib;
{
  options.my.boot = {
    secureboot = {
      enable = mkEnableOption "Whether secure boot is enabled.";
    };
    splash = {
      enable = mkEnableOption "Whether a splash image should be shown on boot.";
    };
    binfmt.emulatedSystems = mkOption {
      description = "Emulated systems";
      type = with types; listOf str;
      default = [ ];
    };
  };
}
