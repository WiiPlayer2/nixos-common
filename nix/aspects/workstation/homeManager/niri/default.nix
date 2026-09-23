let
  modifier = "Mod";
in
{
  wayland.windowManager.niri = {
    enable = true;
    settings = {
      prefer-no-csd = { };

      input = {
        keyboard = {
          numlock = { };
        };

        touchpad = {
          tap = { };
          tap-button-map = "left-right-middle";
          dwt = { };
          dwtp = { };
          natural-scroll = { };
        };

        focus-follows-mouse = { };
        workspace-auto-back-and-forth = { };
      };

      layout = {
        gaps = 15;
        empty-workspace-above-first = { };

        border = {
          width = 5;
        };

        focus-ring = {
          width = 5;
        };

        shadow = {
          on = { };
          softness = 20;
        };

        struts = {
          left = 15;
          right = 15;
          top = 15;
          bottom = 15;
        };
      };

      blur = {
        passes = 3;
        offset = 5.0;
      };

      cursor.hide-after-inactive-ms = 5000;

      binds = {
        "Control+Alt+L".spawn = [
          "loginctl"
          "lock-session"
        ];
        "${modifier}+Shift+V".spawn = [
          "dms"
          "ipc"
          "clipboard"
          "open"
        ];
        "${modifier}+Shift+E".spawn = [
          "dms"
          "ipc"
          "powermenu"
          "open"
        ];
        "${modifier}+Shift+R".spawn = [
          "dms"
          "restart"
        ]; # sway: reload, exec dms restart, exec kanshictl reload
        "${modifier}+D".spawn = [
          "dms"
          "ipc"
          "spotlight-bar"
          "openWith"
          "all"
        ];

        # Screenshots
        "Print".spawn = [
          "dms"
          "ipc"
          "quickCapture"
          "screenshot"
          "all"
          "edit"
        ];
        "Control+Print".spawn = [
          "dms"
          "ipc"
          "quickCapture"
          "screenshot"
          "region"
          "edit"
        ];

        # Display
        "${modifier}+P".spawn = [
          "dms"
          "ipc"
          "settings"
          "focusOrToggleWith"
          "displays"
        ];
      };

      # _children = [
      #   {
      #     window-rule = {
      #       background-effect.blur = true;
      #     };
      #   }
      # ];
    };
  };
}
