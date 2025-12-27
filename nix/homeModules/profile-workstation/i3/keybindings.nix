{ lib, pkgs, ... }:
with lib;
{
  xsession.windowManager.i3.config.keybindings =
    # let
    #   modifier = config.xsession.windowManager.i3.config.modifier;
    # in
    mkOptionDefault {
      # TODO: add notifications
      "XF86AudioMute" =
        "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioLowerVolume" =
        "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioRaiseVolume" =
        "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
    };
}
