{ lib
, config
, pkgs
, ...
}@args:
with lib;
let
  cfg = config.wayland.windowManager.sway;
  cfgi3 = config.xsession.windowManager.i3;
in
{
  # TODO: this should not be mapped but properly extracted from i3 config
  wayland.windowManager.sway = {
    package = pkgs.swayfx;
    config =
      let
        sharedConfig = import ../../shared/i3-sway args {
          stylixBarConfig = config.stylix.targets.sway.exportedBarConfig;
        };
        overrideConfig = {
          input = {
            "*" = {
              xkb_layout = config.my.config.keyboard.layout;
            };
          };
          startup =
            let
              mapToSway =
                { command, always, ... }:
                {
                  inherit command always;
                };
              mappedItems = map mapToSway cfgi3.config.startup;
            in
            mappedItems;
        };
        mergedConfig = recursiveUpdate (recursiveUpdate cfgi3.config sharedConfig) overrideConfig;
      in
      mergedConfig;
    checkConfig = false;
    extraConfig = ''
      blur enable
      shadows enable
    '';
    wrapperFeatures.gtk = true;
  };
}
