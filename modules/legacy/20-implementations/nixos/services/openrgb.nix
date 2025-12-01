{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.services.openrgb;
in
{
  config = mkIf cfg.enable {
    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    my.startup.openrgb.command = "${pkgs.openrgb-with-all-plugins}/bin/openrgb --startminimized";
  };
}
