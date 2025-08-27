{ lib, config, pkgs, ... }:
with lib;
{
  options.unified.profiles.graphical.enable = mkEnableOption "";

  config = mkIf config.unified.profiles.graphical.enable {
    home.packages = with pkgs; [
      firefox
      arandr
      sxcs
      xmagnify
      mission-center

      camset # webcam config
    ];

    programs.vscode.enable = true;
  };
}
