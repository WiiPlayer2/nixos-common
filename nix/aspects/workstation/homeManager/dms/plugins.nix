{
  programs.dank-material-shell.plugins =
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
}
