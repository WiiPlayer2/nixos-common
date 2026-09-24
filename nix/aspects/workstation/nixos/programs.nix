{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  programs = {
    sway = {
      enable = true;
      package = pkgs.swayfx;
    };
    niri.enable = true;
    uwsm = {
      enable = true;
      waylandCompositors.sway = {
        prettyName = "Sway";
        comment = "Sway compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/sway";
      };
    };

    dsearch.enable = true;
    dms-greeter = {
      enable = true;
      configHome = config.users.users.${builtins.elemAt config.darklink.mainUsers.users 0}.home;
      compositor = {
        # name = "sway";
        # # Turn off display after 15 minutes
        # customConfig = ''
        #   input "*" {
        #     xkb_layout de
        #   }
        #   exec ${getExe pkgs.swayidle} -d -w timeout 900 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'
        # '';

        name = "niri";
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
