{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.blender;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      blender
    ];
  };
}
