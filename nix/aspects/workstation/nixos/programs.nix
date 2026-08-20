{ lib, pkgs, ... }:
with lib;
let
  greeterSwayidle = null;
in
{
  programs = {
    sway = {
      enable = true;
      package = pkgs.swayfx;
    };
    # niri.enable = true;
    uwsm = {
      enable = true;
      waylandCompositors.sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };

    dsearch.enable = true;
    dank-material-shell.greeter = {
      enable = true;
      compositor = {
        name = "sway";
        # Turn off display after 15 minutes
        customConfig = ''
          exec ${getExe pkgs.swayidle} -d -w timeout 900 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'
        '';
      };
    };

    seahorse.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      pavucontrol
      libnotify
    ];
    cinnamon.excludePackages = with pkgs; [
      gnome-terminal
      xed-editor
      gnome-calendar
      gnome-screenshot
    ];
  };

  xdg.portal.wlr.settings = {
    screencast = {
      chooser_type = "simple";
      chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
    };
  };
}
