{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.terminal;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      programs.hyfetch = {
        enable = true;
        settings = {
          preset = "nonbinary";
          mode = "rgb";
          color_align = {
            mode = "horizontal";
          };
        };
      };
    };
}
