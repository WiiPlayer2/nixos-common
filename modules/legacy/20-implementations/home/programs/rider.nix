{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.rider;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # fix for toolbar issue: https://youtrack.jetbrains.com/issue/IJPL-122525/Menu-bar-missing-on-all-windows-except-one-on-tiling-WM-under-WSLg#focus=Comments-27-7581609.0-0
      jetbrains.rider
    ];
  };
}
