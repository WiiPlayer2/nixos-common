{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.graphical.social;

  silent-signal-desktop = pkgs.makeDesktopItem {
    name = "signal";
    desktopName = "Signal";
    exec = "${pkgs.signal-desktop.meta.mainProgram} --use-tray-icon --start-in-tray --password-store=\"gnome-libsecret\" %U";
    type = "Application";
    terminal = false;
    icon = "signal-desktop";
    comment = "Private messaging from your desktop";
    startupWMClass = "signal";
    mimeTypes = [
      "x-scheme-handler/sgnl"
      "x-scheme-handler/signalcaptcha"
    ];
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  };
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

      # my.startup = {
      #   signal-desktop.command = "signal-desktop --use-tray-icon --start-in-tray --password-store=\"gnome-libsecret\"";
      #   rocketchat-desktop.command = "rocketchat-desktop";
      # };

      xdg.autostart.entries = [
        "${silent-signal-desktop}"
        "${pkgs.rocketchat-desktop}/share/applications/rocketchat-desktop.desktop"
      ];
    };
}
