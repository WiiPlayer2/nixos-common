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
      home.packages = with pkgs; [
        (writeShellScriptBin "show-android-device" ''
          scrcpy --turn-screen-off --show-touches --stay-awake --keyboard=uhid
        '')
      ];
    };
}
