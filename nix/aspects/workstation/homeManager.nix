{ inputs, ... }:
{ lib, config, ... }:
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
              "dankPomodoroTimer"
              "timer"
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
            openOnOverview = true;
            transparency = 0.8;
            widgetTransparency = 0.95;
          }
        ];

        useAutoLocation = true; # TODO: maybe hardcode location
        popupTransparency = mkOverride 90 0.95; # set by stylix
        notificationHistorySaveLow = false;
        notificationPopupPosition = 3; # bottom right
        osdAlwaysShowValue = true;
        osdMediaPlaybackEnabled = true;
        osdPowerProfileEnabled = true;
        showWorkspaceName = true;
      };

      plugins =
        let
          installAndEnable = {
            enable = true;
            settings.enabled = true;
          };
        in
        {
          dankKDEConnect = installAndEnable;
          ocrScanner = installAndEnable;
          bongoCat = installAndEnable;
          kaomojiPicker = installAndEnable;
          dankDiskUsage = installAndEnable;
          nextBootSelector = installAndEnable;
          linuxWallpaperEngine = installAndEnable;
          dankStickerSearch = installAndEnable;
          dankGifSearch = installAndEnable;
          dankPomodoroTimer = installAndEnable;
          timer = installAndEnable;
          usbManager = installAndEnable;
          calculator = installAndEnable;
          qrGenerator = installAndEnable;
        };
    };
    wezterm.enable = true; # currently managed outside
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = mkForce [ ];
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        {
          "${modifier}+Shift+v" = "dms ipc clipboard open";
        };
    };
  };
}
