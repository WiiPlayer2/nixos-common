{ lib, pkgs, ... }:
with lib;
{
  home.packages = with pkgs; [
    cinnamon-screensaver
  ];

  xsession.windowManager.i3.config = {
    startup = [
      { command = "${pkgs.cinnamon-screensaver}/bin/cinnamon-screensaver --hold"; }
    ];

    keybindings =
      # let
      #   modifier = config.xsession.windowManager.i3.config.modifier;
      # in
      mkOptionDefault {
        "Control+Mod1+L" = "exec ${pkgs.cinnamon-screensaver}/bin/cinnamon-screensaver-command --lock";
      };
  };

  services.inhibridge.enable = true;
}
