{ pkgs
, lib
, config
, ...
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
        discord
        rocketchat-desktop
        # overlayed # TODO fix connection
        overlayed-appimage
      ];

      my.startup = {
        signal-desktop.command = "signal-desktop --use-tray-icon --start-in-tray";
        discord.command = "${getExe pkgs.discord} --start-minimized";
        rocketchat-desktop.command = "rocketchat-desktop";
      };
    };
}
