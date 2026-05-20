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
      bongoCat = installAndEnable;
      calculator = installAndEnable;
      dankDiskUsage = installAndEnable;
      dankGifSearch = installAndEnable;
      dankKDEConnect = installAndEnable;
      dankPomodoroTimer = installAndEnable;
      dankStickerSearch = installAndEnable;
      kaomojiPicker = installAndEnable;
      linuxWallpaperEngine = installAndEnable;
      nextBootSelector = installAndEnable;
      ocrScanner = installAndEnable;
      qrGenerator = installAndEnable;
      timer = installAndEnable;
      usbManager = installAndEnable;
    };

  home.packages = with pkgs; [
    # bongoCat
    libinput
    evtest

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
}
