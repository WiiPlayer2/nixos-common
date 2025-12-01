{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.bubbly;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bubbly
    ];
  };
}
