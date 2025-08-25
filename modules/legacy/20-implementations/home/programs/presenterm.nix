{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.presenterm;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      presenterm
    ];
  };
}
