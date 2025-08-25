{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.secureboot;
in
{
  options.my.features.secureboot = {
    enable = mkEnableOption "Secure boot";
  };

  config.my = mkIf cfg.enable {
    boot = {
      secureboot = {
        enable = true;
      };
    };
  };
}
