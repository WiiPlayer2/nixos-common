{ lib
, config
, ...
}:
let
  cfg = config.my.components.graphical.windowManager.i3;
  cfgGraphical = config.my.components.graphical;
in
{
  config =
    with lib;
    mkIf (cfgGraphical.enable && cfg.enable) {
      xsession.windowManager.i3.enable = true;
    };
}
