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
      programs.wezterm.enable = true;
    };
}
