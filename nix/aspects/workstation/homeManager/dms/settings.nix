{ lib, config, ... }:
with lib;
{
  programs.dank-material-shell = {
    managedSettings = {
      barConfigs = {
        default = {
          name = "Main Bar";
          enabled = true;
          position = 0; # top
          screenPreferences = [
            "all"
          ];
          leftWidgets = [
            "bongoCat"
            "workspaceSwitcher"
            "musicLyrics"
          ];
          centerWidgets = [
            {
              id = "music";
              enabled = true;
              mediaSize = 0;
            }
            "clock"
            "weather"
          ];
          rightWidgets = [
            "network_speed_monitor"
            "systemMonitorPlus"
            "dankDiskUsage"
            "notificationButton"
            "privacyIndicator"
            "controlCenterButton"
          ];
          openOnOverview = true;
          transparency = 0.8;
          widgetTransparency = 0.95;
        };

        tools = {
          id = "tools";
          name = "Tools Bar";
          enabled = true;
          position = 1; # bottom
          screenPreferences = [
            "all"
          ];
          transparency = 0.8;
          widgetTransparency = 0.95;
          autoHide = true;

          leftWidgets = [
            "dankPomodoroTimer"
            # "timer" # it's broken, I could try to patch it so it actually works
            "dankKDEConnect"
            "dankTodo"
            "dockerManager"
          ];
          centerWidgets = [
            "clipboard"
            "ocrScanner"
            "qrGenerator"
            "colorPicker"
            "notepadButton"
          ];
          rightWidgets = [
            "usbManager"
            "nixMonitor"
            "systemTray"
          ];
        };
      };
    };
    settings = {
      # Control Center
      controlCenterShowBluetoothIcon = false;
      controlCenterShowAudioIcon = false;
      controlCenterShowBatteryIcon = true;
      controlCenterShowPrinterIcon = true;
      controlCenterWidgets =
        let
          widget = id: width: {
            inherit id width;
            enabled = true;
          };
        in
        [
          (widget "idleInhibitor" 25)
          (widget "nightMode" 25)
          (widget "darkMode" 25)
          (widget "battery" 25)

          (widget "volumeSlider" 50)
          (widget "brightnessSlider" 50)

          (widget "wifi" 25)
          (widget "builtin_vpn" 50)
          (widget "bluetooth" 25)

          (widget "builtin_cups" 50)
          (widget "plugin_nextBootSelector" 50)

          (widget "audioOutput" 50)
          (widget "audioInput" 50)
        ];

      useAutoLocation = true; # TODO: maybe hardcode location
      popupTransparency = mkOverride 90 0.95; # set by stylix
      osdAlwaysShowValue = true;
      osdMediaPlaybackEnabled = true;
      osdPowerProfileEnabled = true;
      showWorkspaceName = true;

      # Notifications
      # Notification Popups
      notificationPopupPosition = 3; # bottom right
      notificationOverlayEnabled = true;

      # History Settings
      notificationHistorySaveLow = false;

      # Lock Screen layout
      lockScreenNotificationMode = 1; # Count only

      # Lock Screen behaviour
      lockBeforeSuspend = true;
      enableFprint = true;
      enableU2f = true;
      u2fMode = "or";

      # Idle Settings
      acProfileName = "1"; # Balanced
      acLockTimeout = 900;
      acMonitorTimeout = 1200;
      acSuspendTimeout = 1800;
      batteryProfileName = "0"; # Power Saver
      batteryLockTimeout = 300;
      batteryMonitorTimeout = 300;
      batterySuspendTimeout = 600;
    };
  };
}
