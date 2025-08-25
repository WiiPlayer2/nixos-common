{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.opentabletdriver;
in
{
  config = mkIf cfg.enable {
    hardware.opentabletdriver.enable = true;
  };
}
