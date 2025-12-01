{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  # TODO: inject asset path through config or special arg
  # notificationSound = ../../../../../../../assets/sounds/notifications/notification-18-270129.mp3;
  notificationSound = config.my.assets.files.sounds.notifications."notification-18-270129.mp3";
  notifyScript = pkgs.writeShellScript "pomodoro-notify" ''
    MSG="$1"
    notify-send --urgency=critical Pomodoro "$MSG"
    ${pkgs.ffmpeg}/bin/ffplay -v 0 -nodisp -autoexit "${notificationSound}"
  '';
in
{
  config.my.components.graphical.windowManager.i3.extraBlocks.pomodoro = {
    bar = "top";
    block = {
      block = "pomodoro";
      notify_cmd = "${notifyScript} '{msg}'";
    };
  };
}
