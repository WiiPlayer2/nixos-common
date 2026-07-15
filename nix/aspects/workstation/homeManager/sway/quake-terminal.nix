{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  xSize = 60;
  ySize = 60;
  yOffset = 2;
  xOffset = (100 - xSize) / 2;
  sharedCommands = "resize set ${toString xSize} ppt ${toString ySize} ppt, move position ${toString xOffset} ppt ${toString yOffset} ppt, focus";
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
      for_window [app_id="quake-terminal"] floating enable, sticky enable, mark quake-terminal, border pixel 10, ${sharedCommands}
    '';
  };
}
