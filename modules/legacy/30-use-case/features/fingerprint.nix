{ lib, ... }:
with lib;
{
  options.my.features.fingerprint = {
    enable = mkEnableOption "Fingerprint";
  };
}
