{ pkgs, ... }:
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
      dankDiskUsage = installAndEnable;
      dankGifSearch = installAndEnable;
      dankHooks = {
        enable = true;
        settings.sessionUnlocked = "keepassxc-unlock";
      };
      dankKDEConnect = installAndEnable;
      dankPomodoroTimer = installAndEnable;
      dankStickerSearch = installAndEnable;
      kaomojiPicker = installAndEnable;
      linuxWallpaperEngine = installAndEnable;
      nextBootSelector = installAndEnable;
      nixMonitor = {
        enable = true;
        settings.gcThresholdGB = 150; # TODO: might need to reduce in the future
      };
      nixPackageRunner = installAndEnable;
      ocrScanner = installAndEnable;
      qrGenerator = installAndEnable;
      timer = installAndEnable;
      usbManager = installAndEnable;
    };

  home.packages = with pkgs; [
    # bongoCat
    libinput
    evtest

    # linuxWallpaperEngine
    linux-wallpaperengine

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

    # usbManager
    udisks
    jq
  ];

  # linuxWallpaperEngine
  # services.linux-wallpaperengine = {
  #   enable = true;
  # };
}
