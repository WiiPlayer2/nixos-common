{ pkgs, ... }:
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
      compositor.name = "sway";
    };

    seahorse.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      pavucontrol
    ];
    cinnamon.excludePackages = with pkgs; [
      gnome-terminal
      xed-editor
      gnome-calendar
      gnome-screenshot
    ];
  };
}
