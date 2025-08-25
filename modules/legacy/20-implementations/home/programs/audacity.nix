{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.audacity;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      audacity
    ];
  };
}
