{ lib, ... }:
with lib;
{
  options.my.features.wakeonlan = {
    enable = mkEnableOption "Wake-On-LAN";
    devices = mkOption {
      description = "The devices for which to enable WOL";
      type = with types; listOf str;
      default = [ ];
    };
  };
}
