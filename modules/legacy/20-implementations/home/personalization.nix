{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.personalization;
in
{
  # Do not use these settings directly.
  # config.stylix = {
  #   enable = config.my.os.type != "nix-on-droid";
  #   base16Scheme =
  #     let
  #       pathStr = toString cfg.colorScheme;
  #     in
  #     if substring 0 1 pathStr == "/" then
  #       cfg.colorScheme
  #     else
  #       "${pkgs.base16-schemes}/share/themes/${cfg.colorScheme}.yaml";
  #   targets = {
  #     # needs some manual migration
  #     firefox = {
  #       profileNames = [
  #         "default-release"
  #       ];
  #     };
  #   };
  #   image = config.my.assets.files.wallpaper.landscape."6a826504a7a871124e8184fcc519bd83.sfw.jpg";
  #   fonts = with pkgs; rec {
  #     sansSerif = serif;
  #     serif = {
  #       package = ubuntu_font_family;
  #       name = "Ubuntu";
  #     };
  #     monospace = {
  #       # TODO: this should be FiraCode but for some reason the font does not work correctly everywhere
  #       package = nerd-fonts.fira-mono;
  #       name = "FiraMono Nerd Font";
  #     };
  #     sizes = {
  #       desktop = 12; # = 10;
  #       applications = 12; # = 12;
  #       # terminal = applications;
  #       popups = 14; # = desktop;
  #     };
  #   };
  # };
}
