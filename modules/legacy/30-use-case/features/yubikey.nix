{ lib, ... }:
with lib;
{
  options.my.features.yubikey = {
    enable = mkEnableOption "Yubikey authentication";
  };
}
