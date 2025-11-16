{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.programs.wezterm;
in
{
  config = mkIf cfg.enable {
    programs.wezterm = {
      # package = pkgs.wezterm-unstable;
      enableZshIntegration = true;
      enableBashIntegration = true;
      # TODO: config from folder should be moved here or cleaned up properly
      # extraConfig = ''
      #   return require 'cfg/config'
      # '';
      extraConfig = mkMerge [
        ''
          -- config.front_end = "OpenGL"

          -- for some reason WezTerm does not launch zsh on kiryu (maybe due to AD login)
          -- config.default_prog = { 'zsh' }
          config.hide_tab_bar_if_only_one_tab = true
          config.mux_enable_ssh_agent = false

          config.exec_domains = {}
          -- distrobox.add_distrobox_domains(config.exec_domains)
          config.background = {
            {
              source = {
                File = os.getenv( "HOME" ) .. '/Dropbox/Bilder/Wallpaper/untagged/Touhou/Th06/Sakuya Izayoi/12501205.png',
              },
              hsb = { brightness = 0.1 }, -- TODO: fix this to apply proper styled color etc., but first the background image needs to be cut out
              horizontal_align = "Right",
            },
          }
        ''
      ];
    };

    home.packages = with pkgs; [
      # wezterm
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
  };
}
