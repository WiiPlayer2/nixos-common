{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.prusa-slicer;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      prusa-slicer
    ];
  };
}
