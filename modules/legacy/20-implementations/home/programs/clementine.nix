{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.clementine;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      clementine
    ];
  };
}
