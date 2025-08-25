{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.finamp;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      finamp
    ];
  };
}
