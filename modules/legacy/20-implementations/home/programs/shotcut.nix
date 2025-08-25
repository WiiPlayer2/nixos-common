{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.shotcut;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      shotcut
    ];
  };
}
