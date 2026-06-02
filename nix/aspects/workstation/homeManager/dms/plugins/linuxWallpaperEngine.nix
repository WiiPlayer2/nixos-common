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
      # pauseOnBattery = true;
      generateStaticWallpaper = true;

      sceneSettings =
        let
          mkScene =
            {
              scaling ? "fill",
              silent ? false,
              screenshotDelay ? 150,
              ...
            }@attrs:
            {
              inherit scaling silent screenshotDelay;
            }
            // attrs;
          simpleScenes = [
            "3702941539"
            "3727389452"
            "3721632201"
            "3713059335"
            "3704235487"
            "3736033678"
            "1790286170"
            "2784878915"
            "2604819315"
            "2764013909"
            "1762759566"
            "1274596667"
            "2370221719"
            "1582922261"
            "930835837"
            "1251922080"
            "1774999551"
            "863122799"
            "1915157341"
            "839130772"
            "2122436849"
            "1210752799"
            "1618674660"
            "1403303673"
            "1651833100"
            "1475621590"
            "1602818637"
            "1586038665"
            "1259370814"
            "1508537729"
            "1446579260"
            "1190785367"
            "945917354"
            "1118905221"
            "1216797426"
            "863821161"
            "845514446"
            "821372791"
            "921046352"
            "842477361"
            "1351869888"
            "1088210431"
          ];
          simpleSceneSettings = genAttrs simpleScenes (_: mkScene { });
        in
        simpleSceneSettings;
    };
  };
}
