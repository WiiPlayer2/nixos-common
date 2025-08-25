{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.poptracker;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      poptracker
    ];
  };
}
