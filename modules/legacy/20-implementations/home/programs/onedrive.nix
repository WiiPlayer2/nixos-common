{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.onedrive;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      onedrive
      onedrivegui
    ];

    my.startup.onedrive.command = "${pkgs.onedrivegui}/bin/onedrivegui";
  };
}
