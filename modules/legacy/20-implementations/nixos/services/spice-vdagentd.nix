{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.spice-vdagentd;
in
{
  config = mkIf cfg.enable {
    services.spice-vdagentd.enable = true;
  };
}
