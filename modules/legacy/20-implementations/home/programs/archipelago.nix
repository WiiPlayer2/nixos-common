{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.archipelago;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # nix-archipelago.archipelago-appimage
      archipelago
    ];
  };
}
