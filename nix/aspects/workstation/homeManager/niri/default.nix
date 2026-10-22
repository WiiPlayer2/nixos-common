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
      include "dms/outputs.kdl"
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
          # more for left/right to better see the neighboring window
          left = 15 * 2;
          right = 15 * 2;
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
        "${modifier}+Shift+V" = {
          _props.hotkey-overlay-title = "Open Clipboard History";
          spawn = [
            "dms"
            "ipc"
            "clipboard"
            "open"
          ];
        };
        "${modifier}+Shift+E" = {
          _props.hotkey-overlay-title = "Open Power Menu";
          spawn = [
            "dms"
            "ipc"
            "powermenu"
            "open"
          ];
        };
        "${modifier}+Shift+R" = {
          _props.hotkey-overlay-title = "Restart DMS";
          spawn = [
            "dms"
            "restart"
          ];
        }; # sway: reload, exec dms restart, exec kanshictl reload
        "${modifier}+D" = {
          _props.hotkey-overlay-title = "Open Spotlight";
          spawn = [
            "dms"
            "ipc"
            "spotlight-bar"
            "openWith"
            "all"
          ];
        };

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
        "XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "audio"
            "mute"
          ];
        };
        "XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "audio"
            "decrement"
            "5"
          ];
        };
        "XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = [
            "dms"
            "ipc"
            "audio"
            "increment"
            "5"
          ];
        };
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
        "XF86MonBrightnessDown" = {
          _props.hotkey-overlay-title = "Decrease Brightness";
          spawn = [
            "dms"
            "ipc"
            "brightness"
            "decrement"
            "5"
            ""
          ];
        };
        "XF86MonBrightnessUp" = {
          _props.hotkey-overlay-title = "Increase Brightness";
          spawn = [
            "dms"
            "ipc"
            "brightness"
            "increment"
            "5"
            ""
          ];
        };
        "${modifier}+P" = {
          _props.hotkey-overlay-title = "Open Displays";
          spawn = [
            "dms"
            "ipc"
            "settings"
            "focusOrToggleWith"
            "displays"
          ];
        };

        # Applications
        "${modifier}+Return" = {
          _props.hotkey-overlay-title = "Open a Terminal";
          spawn = [ "wezterm" ];
        };

        # Windows & Workspaces
        "${modifier}+Control+Left".move-workspace-to-monitor-left = { };
        "${modifier}+Control+Right".move-workspace-to-monitor-right = { };
        "${modifier}+Control+Up".move-workspace-to-monitor-up = { };
        "${modifier}+Control+Down".move-workspace-to-monitor-down = { };

        # "${modifier}+Shift+Left".move-column-left-or-to-monitor-left = { };
        # "${modifier}+Shift+Right".move-column-right-or-to-monitor-right = { };
        # "${modifier}+Shift+Up".move-window-up-or-to-workspace-up = { };
        # "${modifier}+Shift+Down".move-window-down-or-to-workspace-down = { };
        "${modifier}+Shift+Left".move-column-left = { };
        "${modifier}+Shift+Right".move-column-right = { };
        "${modifier}+Shift+Up".move-window-up = { };
        "${modifier}+Shift+Down".move-window-down = { };

        # "${modifier}+Left".focus-column-or-monitor-left = { };
        # "${modifier}+Right".focus-column-or-monitor-right = { };
        "${modifier}+Left".focus-column-left-or-last = { };
        "${modifier}+Right".focus-column-right-or-first = { };
        "${modifier}+Up".focus-window-or-workspace-up = { };
        "${modifier}+Down".focus-window-or-workspace-down = { };
      };

      _children = [
        # Default
        {
          window-rule = {
            background-effect.blur = true;
            geometry-corner-radius = 10;
            clip-to-geometry = true;
            opacity = 0.95;
          };
        }

        # Inactive windows
        {
          window-rule = {
            match._props.is-active = false;
            opacity = 0.7;
          };
        }

        # Floating windows
        {
          window-rule = {
            match._props.is-floating = true;
            # Due to not being able to be configured, it's too annoying to click on buttons
            # baba-is-float = true;
          };
        }

        # Specific applications
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
            match._props = {
              app-id = "firefox$";
            };
            open-maximized = true;
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
            open-focused = false;
          };
        }
        {
          window-rule = {
            match._props = {
              app-id = "superproductivity";
              title = "Super Productivity Task Widget";
            };
            open-floating = true;
          };
        }
        {
          window-rule = {
            match._props = {
              app-id = "hermes";
              title = "Hermes HUD";
            };
            open-floating = true;
            open-focused = false;
            draw-border-with-background = false;
            default-floating-position._props = {
              x = 0;
              y = 0;
              relative-to = "top";
            };
            focus-ring.off = { };
            border.off = { };
            shadow.off = { };
            background-effect = {
              xray = false;
              blur = false;
            };
            opacity = 0.95;
          };
        }
      ];
    };
  };
}
