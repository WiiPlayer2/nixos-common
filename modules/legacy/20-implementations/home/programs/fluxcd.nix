{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.fluxcd;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fluxcd
    ];
  };
}
