{ config, pkgs, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    image = config.my.assets.files.wallpaper.landscape."6a826504a7a871124e8184fcc519bd83.sfw.jpg";
    fonts = with pkgs; rec {
      sansSerif = serif;
      serif = {
        package = ubuntu_font_family;
        name = "Ubuntu";
      };
      monospace = {
        # TODO: this should be FiraCode but for some reason the font does not work correctly everywhere
        package = nerd-fonts.fira-mono;
        name = "FiraMono Nerd Font";
      };
      # sizes = {
      #   desktop = 12; # = 10;
      #   applications = 12; # = 12;
      #   # terminal = applications;
      #   popups = 14; # = desktop;
      # };
    };

    targets.gtksourceview.enable = false;
  };
}
