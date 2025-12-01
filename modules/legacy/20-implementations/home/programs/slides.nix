{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.slides;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      slides
    ];
  };
}
