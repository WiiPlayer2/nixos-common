{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.graphical;
in
{
  options.my.features = {
    graphical = {
      enable = mkEnableOption "Graphical environment";
      drivers = {
        displaylink = {
          enable = mkEnableOption "DisplayLink driver";
        };
        nvidia = {
          enable = mkEnableOption "Proprietary NVidia driver";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    # TODO: enable display manager, desktop manager and window manager here
    my.components = {
      graphical = {
        enable = true;
        windowManager.i3 = {
          enable = true;
          blocks = {
            speedtest.enable = true;
            time.showDate = true;
            flakeUpdates.enable = true;
            notifications.enable = true;
          };
          extraBlocks = {
            weather.enable = true;
            music.enable = true;
          };
        };
        dunst.enable = true;
      };
    };
  };
}
