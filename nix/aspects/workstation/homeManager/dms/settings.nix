{ lib, config, ... }:
with lib;
{
  programs.dank-material-shell.settings = {
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
          "bongoCat"
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
          "privacyIndicator"
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
}
