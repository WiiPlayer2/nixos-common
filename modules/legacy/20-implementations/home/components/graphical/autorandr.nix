{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.my.components.graphical;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      services.autorandr.enable = true;
      programs.autorandr = {
        enable = true;
        hooks = {
          postswitch = {
            "notify-i3" = "${pkgs.i3}/bin/i3-msg restart";
            "re-apply wallpaper" = "${pkgs.procps}/bin/pgrep variety && ${getExe pkgs.variety} --next";
          };
        };
      };
    };
}
