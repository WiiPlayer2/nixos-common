{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.graphical.social;
in
{
  config =
    with lib;
    mkIf cfg.misc {
      home.packages = with pkgs; [
        signal-desktop
        rocketchat-desktop
        # overlayed # TODO fix connection
        overlayed-appimage
      ];

      my.startup = {
        signal-desktop.command = "signal-desktop --use-tray-icon --start-in-tray --password-store=\"gnome-libsecret\"";
        rocketchat-desktop.command = "rocketchat-desktop";
      };
    };
}
