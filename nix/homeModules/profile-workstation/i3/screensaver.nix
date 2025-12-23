{ lib, pkgs, ... }:
with lib;
let
  xsetConfig = pkgs.writeShellApplication {
    name = "xset-config";
    runtimeInputs = with pkgs; [
      xorg.xset
    ];
    text = ''
      xset -dpms
      xset s off
    '';
  };
in
{
  home.packages = with pkgs; [
    cinnamon-screensaver
  ];

  xsession.windowManager.i3.config = {
    startup = [
      { command = "${pkgs.cinnamon-screensaver}/bin/cinnamon-screensaver --hold"; }
      { command = "${getExe xsetConfig}"; }
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
