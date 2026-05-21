{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      bars = mkForce [ ];
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        {
          "Control+Mod1+L" = "exec loginctl lock-session";
          "${modifier}+Shift+v" = "exec dms ipc clipboard open";
          "${modifier}+Shift+e" = mkOverride 90 "exec dms ipc powermenu open";
          "${modifier}+Control+d" = "exec dms ipc launcher openWith all";
          "XF86AudioMute" = "exec dms ipc audio mute";
          "XF86AudioLowerVolume" = "exec dms ipc audio decrement 5";
          "XF86AudioRaiseVolume" = "exec dms ipc audio increment 5";
          "XF86MonBrightnessDown" = "exec dms ipc brightness decrement 5";
          "XF86MonBrightnessUp" = "exec dms ipc brightness increment 5";
          "XF86AudioPlay" = "exec dms ipc mpris playPause";
          "XF86AudioStop" = "exec dms ipc mpris stop";
          "XF86AudioNext" = "exec dms ipc mpris next";
          "XF86AudioPrev" = "exec dms ipc mpris previous";
          "Control+XF86AudioLowerVolume" = "exec dms ipc mpris decrement 5";
          "Control+XF86AudioRaiseVolume" = "exec dms ipc mpris increment 5";
          # TODO: change to "dms ipc settings focusOrToggleWith displays" when sway is supported in dms
          "${modifier}+P" = "exec wdisplays";
        };
    };
  };

  home.packages = with pkgs; [
    wdisplays
  ];
}
