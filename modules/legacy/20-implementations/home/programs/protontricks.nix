{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.protontricks;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      protontricks
    ];
  };
}
