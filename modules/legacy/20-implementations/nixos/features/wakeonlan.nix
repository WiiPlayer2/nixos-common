{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.wakeonlan;
in
{
  config = mkIf cfg.enable {
    networking.interfaces = listToAttrs (
      map (x: {
        name = x;
        value = {
          wakeOnLan.enable = true;
        };
      }) cfg.devices
    );
  };
}
