{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.components.graphical.dunst;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ubuntu_font_family
    ];

    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "keyboard";
          origin = "bottom-right";
          icon_corner_radius = 5;
          transparency = 10;
          gap_size = 5;
          corner_radius = 10;
          # font = "Ubuntu 12"; # managed by stylix
          width = "(300, 800)";
          idle_threshold = "5m";
          fullscreen = "delay";
          dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst";
        };
      };
    };
  };
}
