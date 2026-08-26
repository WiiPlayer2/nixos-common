{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    # TODO: config from folder should be moved here or cleaned up properly
    extraConfig = mkMerge [
      ''
        (require 'cfg/_config')(config, {
          base_color = {
            red = ${config.lib.stylix.colors.base00-rgb-r},
            green = ${config.lib.stylix.colors.base00-rgb-g},
            blue = ${config.lib.stylix.colors.base00-rgb-b},
          },
          -- https://danbooru.donmai.us/posts/11582519
          bg_file = '${
            pkgs.fetchurl {
              url = "https://cdn.donmai.us/original/0a/c9/__izayoi_sakuya_touhou_drawn_by_baba_baba_seimaijo__0ac9eb4dbf0e6d182a862c57c19332b3.png?download=1";
              hash = "sha256-NeobjV3s1EivmSkMaQ+KJSAm/bido+r7TYE8bjMrNKc=";
            }
          }',
          processes = {
            ssh = "#${config.lib.stylix.colors.base0C}",
            sudo = "#${config.lib.stylix.colors.base08}",
          },
        })
      ''
    ];
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "open-wezterm-here" ''
      # This script is a helper that starts a new terminal window
      # in the cwd of the calling process, rather than using the
      # default cwd which is usually the home directory.
      exec wezterm start --cwd "$PWD" -- "$@"
    '')
  ];

  home.file.wezterm = {
    source = ./config;
    target = ".config/wezterm/cfg";
    recursive = true;
  };
}
