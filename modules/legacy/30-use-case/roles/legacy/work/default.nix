{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.my.roles.legacy.work.default;
in
{
  options.my.roles.legacy.work.default = {
    enable = mkEnableOption "Whether to enable the default work role";
  };

  config = mkIf cfg.enable {
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
        development.misc = true;
        social = {
          teams.enable = true;
          tuba.enable = true;
        };
      };
      terminal = {
        enable = true;
        development.misc = true;
      };
    };
    my.programs = {
      nemo.enable = true;
      taskwarrior = {
        enable = true;
        dataLocation = "$HOME/Dropbox/Sync/taskwarrior";
      };
      kubecolor.enable = true;
      cava.enable = true;
      rider.enable = true;
    };
  };
}
