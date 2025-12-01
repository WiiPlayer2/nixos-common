{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.graphical;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      home.packages =
        with pkgs;
        [
          guvcview
          mpv
          scrcpy
          xpra
        ]
        ++ (optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") [
          xwinwrap
        ]);

      services.copyq = {
        enable = true;
      };

      programs.chromium = {
        enable = true;
      };

      my.programs = {
        variety.enable = true;
      };
    };
}
