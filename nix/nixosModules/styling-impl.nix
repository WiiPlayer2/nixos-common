{ inputs, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.pointerCursor = {
          enable = true;
          gtk.enable = true;
          x11.enable = true;

          package = pkgs.catppuccin-cursors.mochaDark;
          name = "catppuccin-mocha-dark-cursors";
        };
      }
    )
  ];

  environment.systemPackages = mkIf config.services.displayManager.enable (
    with pkgs;
    [
      adwaita-icon-theme
    ]
  );
}
