{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.tsrc;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tsrc
    ];
  };
}
