{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.libreoffice;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice-qt6-fresh
    ];
  };
}
