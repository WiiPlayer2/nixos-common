{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.wlx-overlay-s;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wlx-overlay-s
    ];
  };
}
