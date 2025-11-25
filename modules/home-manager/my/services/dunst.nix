{ pkgs, ... }:
{
  services.dunst = {
    settings = {
      global = {
        follow = "keyboard";
        origin = "bottom-right";
        icon_corner_radius = 5;
        transparency = 10;
        gap_size = 5;
        corner_radius = 10;
        width = "(300, 800)";
        idle_threshold = "5m";
        # fullscreen = "delay";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst";
      };

      urgency_critical = {
        override_pause_level = 75;
      };
    };
  };
}
