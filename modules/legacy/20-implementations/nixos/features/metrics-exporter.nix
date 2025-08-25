{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.metrics-exporter;
in
{
  config = mkIf cfg.enable {
    services.prometheus.exporters = {
      node = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
