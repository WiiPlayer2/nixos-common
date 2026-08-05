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
    /*
      https://danbooru.donmai.us/posts/6751881?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+blood
      https://danbooru.donmai.us/posts/6040751?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+blood
      https://danbooru.donmai.us/posts/896217?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+blood+rating%3As
      https://danbooru.donmai.us/posts/7776598?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+blood
      https://danbooru.donmai.us/posts/10430500?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+blood
      https://danbooru.donmai.us/posts/10805576?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+blood
      https://danbooru.donmai.us/posts/10206307?q=parent%3A10206307
      https://danbooru.donmai.us/posts/3264674?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+rating%3As+knife
      https://danbooru.donmai.us/posts/3349474?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+rating%3As+knife
      https://danbooru.donmai.us/posts/3733916?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+rating%3As+knife
      https://danbooru.donmai.us/posts/4117181?q=izayoi_sakuya+width%3A%3E%3D1920+height%3A%3E%3D1080+rating%3As+knife
    */
    image = mkDefault (
      pkgs.fetchurl {
        url = "https://cdn.donmai.us/original/75/2f/__izayoi_sakuya_touhou_drawn_by_kawayabug__752fd07be4ba598882c4df9db399be4f.jpg";
        hash = "sha256-BmPHzmKxOE/rKu2XziS+z8xhsZg4s6NsOUIm9pZQVoc=";
      }
    );

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
