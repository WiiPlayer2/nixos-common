{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.spice-autorandr;
in
{
  config = mkIf cfg.enable {
    services.spice-autorandr.enable = true;
  };
}
