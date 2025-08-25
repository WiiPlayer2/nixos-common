{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.freecad;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      freecad
    ];
  };
}
