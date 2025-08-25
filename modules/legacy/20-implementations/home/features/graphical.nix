{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.graphical;
in
{
  config = mkIf cfg.enable {
    dconf.settings = {
      "org/x/apps/portal" = {
        color-scheme = "prefer-dark";
      };
      # "org/gnome/desktop/interface" = {
      #   gtk-theme = "Mint-Y-Dark-Aqua";
      # };
      "org/cinnamon/theme" = {
        name = "Mint-Y-Dark-Aqua";
      };
      "org/nemo/preferences" = {
        default-folder-viewer = "list-view";
      };
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "open-wezterm-here";
        exec-arg = "--";
      };
    };

    xdg.mimeApps = {
      # enable = true; # TODO: this should be managed but not now
      defaultApplications = {
        "inode/directory" = trace "henlo" "nemo.desktop";
      };
    };
  };
}
