{ lib
, config
, ...
}:
with lib;
let
  cfg = config.my.components.graphical.dunst;
in
{
  config = mkIf cfg.enable {
    services.dunst.enable = true;
  };
}
