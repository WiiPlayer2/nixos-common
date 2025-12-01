{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.atlauncher;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      atlauncher
    ];
  };
}
