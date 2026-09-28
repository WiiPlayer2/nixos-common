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
    # my.startup.openrgb.command = "${pkgs.openrgb-with-all-plugins}/bin/openrgb --startminimized";
    xdg.autostart.entries = [
      "${pkgs.openrgb-with-all-plugins}/share/applications/org.openrgb.OpenRGB.desktop"
    ];
  };
}
