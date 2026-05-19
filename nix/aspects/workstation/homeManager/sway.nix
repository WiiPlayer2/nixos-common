{ lib, config, ... }:
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
          "${modifier}+Shift+v" = "dms ipc clipboard open";
        };
    };
  };
}
