{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.vlc;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
    ];
  };
}
