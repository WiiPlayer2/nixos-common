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
          (require 'cfg/_config')(config, {
            base_color = "#${config.lib.stylix.colors.base00}",
            bg_file = '${config.my.assets.root + /images/wezterm_bg.png}',
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
  };
}
