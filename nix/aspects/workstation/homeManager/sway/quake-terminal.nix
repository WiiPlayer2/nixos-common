{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  sharedCommands = "resize set 50 ppt 50 ppt, move position 25 ppt 0 ppt, focus";
  script = pkgs.writeShellApplication {
    name = "toggle-quake-terminal";
    text = ''
      if swaymsg '[con_mark="quake-terminal"] nop'; then
        # terminal exists
        if swaymsg '[con_mark="quake-terminal" con_id="__focused__"] nop'; then
          # terminal focused
          swaymsg '[con_mark="quake-terminal"] move scratchpad'
        else
          # terminal unfocused
          swaymsg '[con_mark="quake-terminal"] move container to output current, ${sharedCommands}'
        fi
      else
        # terminal doesn't exist
        exec wezterm start --class quake-terminal
      fi
    '';
  };
in
{
  wayland.windowManager.sway = {
    config.keybindings."${config.wayland.windowManager.sway.config.modifier}+space" =
      mkOverride 90 "exec ${getExe script}";
    extraConfig = ''
      for_window [app_id="quake-terminal"] floating enable, sticky enable, mark quake-terminal, ${sharedCommands}
    '';
  };
}
