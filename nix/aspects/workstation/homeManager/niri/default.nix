let
  modifier = "Mod";
in
{
  wayland.windowManager.niri = {
    enable = true;
    enableDefaultConfig = true;
    checkConfig = false; # Needed because of the DMS includes below
    extraConfig = ''
      // DMS
      // include "dms/alttab.kdl"
      // include "dms/binds.kdl"
      // include "dms/colors.kdl"
      // include "dms/cursor.kdl"
      // include "dms/layout.kdl"
      // include "dms/outputs.kdl"
      include "dms/windowrules.kdl"
      include "dms/wpblur.kdl"
    '';
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

        focus-follows-mouse._props = {
          max-scroll-amount = "35%";
        };
        workspace-auto-back-and-forth = { };
      };

      layout = {
        gaps = 15;
        # empty-workspace-above-first = { };

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

        # Audio
        "XF86AudioMute".spawn = [
          "dms"
          "ipc"
          "audio"
          "mute"
        ];
        "XF86AudioLowerVolume".spawn = [
          "dms"
          "ipc"
          "audio"
          "decrement"
          "5"
        ];
        "XF86AudioRaiseVolume".spawn = [
          "dms"
          "ipc"
          "audio"
          "increment"
          "5"
        ];
        "Control+XF86AudioLowerVolume".spawn = [
          "dms"
          "ipc"
          "mpris"
          "decrement"
          "5"
        ];
        "Control+XF86AudioRaiseVolume".spawn = [
          "dms"
          "ipc"
          "mpris"
          "increment"
          "5"
        ];
        "XF86AudioPlay".spawn = [
          "dms"
          "ipc"
          "mpris"
          "playPause"
        ];
        "XF86AudioStop".spawn = [
          "dms"
          "ipc"
          "mpris"
          "stop"
        ];
        "XF86AudioNext".spawn = [
          "dms"
          "ipc"
          "mpris"
          "next"
        ];
        "XF86AudioPrev".spawn = [
          "dms"
          "ipc"
          "mpris"
          "previous"
        ];

        # Display
        "XF86MonBrightnessDown".spawn = [
          "dms"
          "ipc"
          "brightness"
          "decrement"
          "5"
        ];
        "XF86MonBrightnessUp".spawn = [
          "dms"
          "ipc"
          "brightness"
          "increment"
          "5"
        ];
        "${modifier}+P".spawn = [
          "dms"
          "ipc"
          "settings"
          "focusOrToggleWith"
          "displays"
        ];

        # Applications
        "${modifier}+Return".spawn = [ "wezterm" ];

        # Windows & Workspaces
        "${modifier}+Control+Left".move-workspace-to-monitor-left = { };
        "${modifier}+Control+Right".move-workspace-to-monitor-right = { };
        "${modifier}+Control+Up".move-workspace-to-monitor-up = { };
        "${modifier}+Control+Down".move-workspace-to-monitor-down = { };

        "${modifier}+Shift+Left".move-column-left-or-to-monitor-left = { };
        "${modifier}+Shift+Right".move-column-right-or-to-monitor-right = { };
        "${modifier}+Shift+Up".move-window-up-or-to-workspace-up = { };
        "${modifier}+Shift+Down".move-window-down-or-to-workspace-down = { };

        "${modifier}+Up".focus-window-or-workspace-up = { };
        "${modifier}+Down".focus-window-or-workspace-down = { };
      };

      _children = [
        {
          window-rule = {
            background-effect.blur = true;
            geometry-corner-radius = 10;
            clip-to-geometry = true;
          };
        }
        {
          window-rule = {
            match._props.is-floating = true;
            baba-is-float = true;
          };
        }
        {
          window-rule = {
            match._props.app-id = ''^org\.wezfurlong\.wezterm$'';
            default-column-width = { };
          };
        }
        {
          window-rule = {
            match._props = {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            };
            open-floating = true;
          };
        }
        {
          window-rule = {
            match._props.app-id = ''^org\.keepassxc\.KeePassXC$'';
            block-out-from = "screen-capture";
          };
        }
        {
          window-rule = {
            match._props = {
              app-id = "steam";
              title = ''^notificationtoasts_\d+_desktop$'';
            };
            default-floating-position._props = {
              x = 10;
              y = 10;
              relative-to = "bottom-right";
            };
            # next niri release (> v26.04)
            # on-xdg-activate = "ignore";
          };
        }
      ];
    };
  };
}
