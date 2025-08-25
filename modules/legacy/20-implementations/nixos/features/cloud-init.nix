{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.cloud-init;
in
{
  config = mkIf cfg.enable {
    services.cloud-init.network.enable = true;
  };
}
