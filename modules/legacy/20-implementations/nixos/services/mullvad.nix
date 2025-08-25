{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.mullvad;
in
{
  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;
  };
}
