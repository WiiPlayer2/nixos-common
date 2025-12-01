{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.wezterm;
in
{
  config = mkIf cfg.enable {
    programs.wezterm = {
      enableZshIntegration = true;
      enableBashIntegration = true;
      # TODO: config from folder should be moved here or cleaned up properly
      extraConfig = mkMerge [
        ''
          config.hide_tab_bar_if_only_one_tab = true
          config.mux_enable_ssh_agent = false

          config.exec_domains = {}
          -- distrobox.add_distrobox_domains(config.exec_domains)
          config.background = {
            {
              source = {
                Color = "#${config.lib.stylix.colors.base00}",
              },
              height = "100%",
              width = "100%",
            },
            {
              source = {
                File = '${config.my.assets.root + /images/wezterm_bg.png}',
              },
              opacity = 0.5,
              horizontal_align = "Right",
              height = "Contain",
              width = "Contain",
            },
          }
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
  };
}
