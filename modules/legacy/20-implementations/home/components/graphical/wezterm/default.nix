{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.my.components.graphical;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      programs.wezterm = {
        enable = true;
        # package = pkgs.wezterm-unstable;
        enableZshIntegration = true;
        enableBashIntegration = true;
        # TODO: config from folder should be moved here or cleaned up properly
        extraConfig = ''
          return require 'cfg/config'
        '';
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
