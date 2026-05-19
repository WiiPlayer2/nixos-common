{ inputs, ... }:
{ lib, ... }:
with lib;
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.modules.default
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
              "dankKDEConnect"
              "clipboard"
              "cpuUsage"
              "memUsage"
              "dankDiskUsage"
              "notificationButton"
              "battery"
              "controlCenterButton"
            ];
            autoHide = true;
            openOnOverview = true;
            transparency = 0.8;
            widgetTransparency = 0.95;
          }
        ];

        useAutoLocation = true; # TODO: maybe hardcode location
      };

      plugins = {
        dankKDEConnect = {
          enable = true;
          settings.enabled = true;
        };
        ocrScanner = {
          enable = true;
          settings.enabled = true;
        };
        bongoCat = {
          enable = true;
          settings.enabled = true;
        };
        kaomojiPicker = {
          enable = true;
          settings.enabled = true;
        };
        dankDiskUsage = {
          enable = true;
          settings.enabled = true;
        };
        nextBootSelector = {
          enable = true;
          settings.enabled = true;
        };
        linuxWallpaperEngine = {
          enable = true;
          settings.enabled = true;
        };
      };
    };
    wezterm.enable = true; # currently managed outside
  };

  wayland.windowManager.sway.enable = true;
}
