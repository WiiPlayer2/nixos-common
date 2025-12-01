{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.aseprite;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      aseprite
    ];
  };
}
