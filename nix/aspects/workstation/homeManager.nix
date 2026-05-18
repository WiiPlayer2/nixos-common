{ inputs, ... }:
{ lib, ... }:
with lib;
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  programs = {
    dank-material-shell = {
      enable = true;
      systemd.enable = true;

      settings = {
        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 0;
            screenPreferences = [
              "all"
            ];
            leftWidgets = [
              "launcherButton"
              "workspaceSwitcher"
              "focusedWindow"
            ];
            centerWidgets = [
              "music"
              "clock"
              "weather"
            ];
            rightWidgets = [
              "systemTray"
              "clipboard"
              "cpuUsage"
              "memUsage"
              "notificationButton"
              "battery"
              "controlCenterButton"
            ];
            autoHide = true;
            openOnOverview = true;
          }
        ];
      };
    };
    wezterm.enable = true; # currently managed outside
  };

  wayland.windowManager.sway = {
    enable = true;
    # TODO: convert legacy my.startup to systemd services ("instant" exec services might be enough)
    config.startup = mkForce [ ];
  };
}
