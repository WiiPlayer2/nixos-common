{ lib, pkgs, ... }:
with lib;
{
  programs.dank-material-shell.plugins =
    let
      installAndEnable = {
        enable = true;
        settings.enabled = true;
      };
    in
    {
      # common dependency for some plugins
      dms-common = {
        src = pkgs.fetchFromGitHub {
          owner = "hthienloc";
          repo = "dms-common";
          rev = "main";
          hash = "sha256-IG5us4/ZYtSZpgyfbrXztBT7EFwUFadLaosjeWBaDFU=";
        };
      };

      bongoCat = installAndEnable;
      calculator = installAndEnable;
      # NOTE: Garbage AI written plugin has non-working settings page.
      # As soon as a field is updated it will be reset to the default values (kitty, -e)
      commandRunner = {
        enable = true;
        settings = {
          terminal = "wezterm";
          execFlag = "start";
        };
      };
      dankCalendar = {
        enable = true;
        settings = {
          showRsvp = mkDefault false;
          notifyMinutes = 5;
        };
      };
      dankDiskUsage = installAndEnable;
      dankGifSearch = installAndEnable;
      dankHooks = {
        enable = true;
        settings.sessionUnlocked = "keepassxc-unlock";
      };
      dankKDEConnect = installAndEnable;
      dankPomodoroTimer = installAndEnable;
      dankRssWidget = installAndEnable;
      dankStickerSearch = installAndEnable;
      dankTodo = installAndEnable;
      dockerManager = installAndEnable;
      gitmojiLauncher = installAndEnable;
      homeAssistantMonitor = installAndEnable;
      intervalCommand = installAndEnable;
      emojiLauncher = installAndEnable;
      kaomojiPicker = installAndEnable;
      musicLyrics = installAndEnable;
      nextBootSelector = installAndEnable;
      nixMonitor = {
        enable = true;
        settings.gcThresholdGB = 150; # TODO: might need to reduce in the future
      };
      nixPackageRunner = installAndEnable;
      ocrScanner = installAndEnable;
      qrGenerator = installAndEnable;
      quickCapture = {
        enable = true;
        settings = {
          skipConfirm = false;
        };
      };
      systemMonitorPlus = {
        enable = true;
        settings = {
          cpuTempEnabled = true;
          ramUsageEnabled = true;
          gpuTempEnabled = true;
        };
      };
      # tasks = installAndEnable; # configure caldav
      timer = installAndEnable;
      usbManager = installAndEnable;
    };

  home.packages = with pkgs; [
    # bongoCat
    libinput
    evtest

    # dankCalendar
    dankcalendar

    # ocrScanner
    (tesseract.override {
      enableLanguages = [
        "eng"
        "deu"
      ];
    })
    wl-clipboard
    curl

    # qrGenerator
    qrencode

    # quickCapture
    # TODO: dms-floaty, wl-clipboard, imagemagick, img2pdf

    # usbManager
    udisks
    jq
  ];
}
