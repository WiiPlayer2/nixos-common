{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.lutris;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
    ];
  };
}
