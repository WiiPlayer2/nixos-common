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
            {
              id = "workspaceSwitcher";
              enabled = true;
              showWorkspaceApps = true;
              showWorkspaceName = true;
              showWorkspaceIndex = false;
              showOccupiedWorkspacesOnly = true;
              workspaceIndicatorCompact = false;
              workspaceIndicatorRoundness = -1;
              workspaceIndicatorStyle = "pills";
            }
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
            "amdGpuMonitor"
            "dankDiskUsage"
            "notificationButton"
            "privacyIndicator"
            {
              id = "controlCenterButton";
              enabled = true;
              showBluetoothIcon = false;
              showAudioIcon = false;
              showAudioPercent = false;
              showBatteryIcon = true;
              showPrinterIcon = true;
              showIdleInhibitorIcon = true;
            }
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
            # "qrGenerator"
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
          widget =
            id: col: row: w: h:
            widget' id col row w h { };
          widget' =
            id: col: row: w: h: attrs:
            {
              inherit
                id
                col
                row
                w
                h
                ;
              enabled = true;
            }
            // attrs;
        in
        [
          (widget "user" 0 0 5 1)
          (widget "settings" 5 0 1 1)
          (widget "lock" 6 0 1 1)
          (widget "power" 7 0 1 1)

          (widget "idleInhibitor" 0 1 2 1)
          (widget "nightMode" 2 1 2 1)
          (widget "darkMode" 4 1 2 1)
          (widget' "battery" 6 1 2 1 {
            batteryStyle = "solid";
            batteryColorMode = "theme";
          })

          (widget "volumeSlider" 0 2 4 1)
          (widget "brightnessSlider" 4 2 4 1)

          (widget "wifi" 0 3 2 1)
          (widget "builtin_vpn" 2 3 4 1)
          (widget "bluetooth" 6 3 2 1)

          (widget "builtin_cups" 0 4 4 1)
          (widget "plugin_nextBootSelector" 4 4 4 1)

          (widget "audioOutput" 0 5 4 1)
          (widget "audioInput" 4 5 4 1)

          (widget "edit" 7 6 1 1)
        ];

      useAutoLocation = true; # TODO: maybe hardcode location
      popupTransparency = mkOverride 90 0.95; # set by stylix
      osdAlwaysShowValue = true;
      osdMediaPlaybackEnabled = true;
      osdPowerProfileEnabled = true;
      showWorkspaceName = true;

      # Workspaces
      showWorkspaceApps = true;
      workspaceActiveAppHighlightEnabled = true;
      workspaceUnfocusedMonitorBorderEnabled = true;
      workspaceUnfocusedMonitorColorMode = "none";
      workspaceUnfocusedMonitorSeparateAppearance = true;

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
