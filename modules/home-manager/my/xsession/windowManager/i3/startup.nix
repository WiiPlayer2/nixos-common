{ lib, config, ... }:
with lib;
let
  mapStartup =
    startup:
    mkIf startup.enable {
      inherit (startup) command;
      notification = false;
    };
  mappedStartups = map (x: mapStartup x.value) (attrsToList config.my.startup);
in
[
  # should be a user service
  {
    command = "spice-vdagent && sleep 5 && systemctl --user start spice-autorandr.service";
    notification = false;
  }
  {
    command = "nitrogen --restore";
    notification = false;
  }
  {
    command = "systemctl --user restart picom";
    # notification = false;
    always = true;
  }
  {
    command = "env XDG_SESSION_DESKTOP=i3 variety";
    notification = false;
  }
]
++ mappedStartups
