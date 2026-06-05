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
              noFullscreenPause ? true,
              ...
            }@attrs:
            {
              inherit
                scaling
                silent
                screenshotDelay
                noFullscreenPause
                ;
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
            "3737398208"
            "3736429464"
            "3733923297"
            "3698037575"
            "3693707741"
            "3691746167"
            "3689041849"
            "3685250767"
            "3684700668"
            "3670877480"
            "3661848503"
            "3649819251"
            "3622983819"
            "3621276667"
            "3620229608"
            "3610605485"
            "3610271907"
            "3588685573"
            "3572060737"
            "3559824846"
            "3553775749"
            "3545949095"
            "3007060480"
            "2972776540"
            "2921782705"
            "3360150199"
          ];
          simpleSceneSettings = genAttrs simpleScenes (_: mkScene { });
        in
        simpleSceneSettings;
    };
  };
}
