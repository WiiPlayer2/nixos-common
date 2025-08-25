{ lib, ... }:
with lib;
{
  options.my.features.metrics-exporter = {
    enable = mkEnableOption "Enabling prometheus metrics exporter";
  };
}
