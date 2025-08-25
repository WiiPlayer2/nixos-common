{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.mob;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mob
    ];
  };
}
