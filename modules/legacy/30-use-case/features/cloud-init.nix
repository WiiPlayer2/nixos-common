{ lib, ... }:
with lib;
{
  options.my.features.cloud-init = {
    enable = mkEnableOption "cloud-init";
  };
}
