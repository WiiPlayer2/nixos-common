{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.inkscape;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inkscape-with-extensions
    ];
  };
}
