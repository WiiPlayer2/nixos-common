{ lib, pkgs, ... }:
with lib;
{
  home.packages = with pkgs; [
    linux-wallpaperengine
  ];

  programs.dank-material-shell.plugins.linuxWallpaperEngine = {
    enable = true;
    settings = {
      pauseOnPowerSaver = true;
      pauseOnBattery = true;
      generateStaticWallpaper = true;
      screenshotDelay = 90;

      sceneSettings =
        let
          mkScene =
            {
              scaling ? "fill",
              silent ? false,
              ...
            }@attrs:
            {
              inherit scaling silent;
            }
            // attrs;
          simpleScenes = [
            "3702941539"
            "3727389452"
            "3721632201"
            "3713059335"
            "3704235487"
          ];
          simpleSceneSettings = genAttrs simpleScenes (_: mkScene { });
        in
        simpleSceneSettings;
    };
  };
}
