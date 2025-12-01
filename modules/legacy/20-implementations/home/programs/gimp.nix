{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.gimp;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp-with-plugins
    ];
  };
}
