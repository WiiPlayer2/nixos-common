{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  stylix = {
    enable = true;
    fonts = with pkgs; rec {
      sansSerif = serif;
      serif = {
        package = ubuntu-classic;
        name = "Ubuntu";
      };
      monospace = {
        # TODO: this should be FiraCode but for some reason the font does not work correctly everywhere
        package = mkDefault nerd-fonts.fira-mono;
        name = mkDefault "FiraMono Nerd Font";
      };
      # sizes = {
      #   desktop = 12; # = 10;
      #   applications = 12; # = 12;
      #   # terminal = applications;
      #   popups = 14; # = desktop;
      # };
    };

    overlays.enable = false;
  };
}
