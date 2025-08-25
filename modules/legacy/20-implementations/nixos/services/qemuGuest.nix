{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.qemuGuest;
in
{
  config = mkIf cfg.enable {
    services.qemuGuest.enable = true;
  };
}
