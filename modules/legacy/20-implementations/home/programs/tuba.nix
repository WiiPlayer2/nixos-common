{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.tuba;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tuba
    ];
  };
}
