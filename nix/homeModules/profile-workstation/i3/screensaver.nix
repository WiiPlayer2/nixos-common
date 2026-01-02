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

  setIdle =
    value:
    pkgs.writeShellApplication {
      name = "set-idle";
      runtimeInputs = with pkgs; [
        dbus
      ];
      text = ''
        dbus-send \
          --system \
          --print-reply \
          --type=method_call \
          --dest=org.freedesktop.login1 \
          "/org/freedesktop/login1/session/_3$XDG_SESSION_ID" \
          org.freedesktop.login1.Session.SetIdleHint \
          'boolean:${value}'
      '';
    };
in
{
  home.packages = with pkgs; [
    cinnamon-screensaver
    xidlehook
  ];

  xsession.windowManager.i3.config = {
    startup = [
      { command = "${pkgs.cinnamon-screensaver}/bin/cinnamon-screensaver --hold"; }
      { command = "${getExe xsetConfig}"; }
      {
        command = "${getExe pkgs.xidlehook} --timer 300 ${escapeShellArg (getExe (setIdle "true"))} ${escapeShellArg (getExe (setIdle "false"))}";
      }
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
