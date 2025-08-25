{ pkgs
, config
, lib
, ...
}:
let
  cfg = config.my.components.graphical.social.element;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      home.packages = with pkgs; [
        element-desktop
      ];

      my.startup.element-desktop.command = "element-desktop --hidden";
    };
}
