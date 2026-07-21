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

  stylix = {
    # use xcursor-viewer to inspect cursor theme
    cursor = {
      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 48;
    };

    fonts = with pkgs; {
      monospace = {
        package = nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
    };
  };
}
