{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "calc";
      runtimeInputs = [
        config.programs.rofi.finalPackage
      ];
      text = ''
        rofi -show calc
      '';
    })
  ];

  # maybe switch to https://albertlauncher.github.io/ or https://ulauncher.io/
  programs.rofi = {
    enable = true;

    plugins = with pkgs; [
      rofi-emoji
      rofi-calc # Does not work for some reason
    ];

    # theme = "solarized_alternate"; # managed by stylix
    # font = "Ubuntu 18"; # managed by stylix
    # terminal = "open-wezterm-here";

    extraConfig = {
      modi = "combi,window,drun,run,emoji,calc,power-menu:rofi-power-menu";
      combi-modi = "drun,run,emoji";
      show-icons = true;
    };
  };
}
