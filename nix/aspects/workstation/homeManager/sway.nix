{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  ensureWorkspaceScript =
    with pkgs;
    writeShellScript "ensure-workspace" ''
      MARK="$1"
      NAME="$2"

      _wsNum=$(swaymsg -t get_workspaces | ${getExe jq} --arg WS "$NAME" '.[] | select(.name | endswith(": " + $WS)) | .num')
      if [[ -z "$_wsNum" ]]; then
        _wsNum=$(swaymsg -t get_tree | ${getExe jq} --arg MARK "$MARK" 'first(recurse(.nodes[]) | select(.type == "workspace") | select(recurse | select(.marks? | index($MARK))) | .num)')
        swaymsg "rename workspace $_wsNum to \"$_wsNum: $NAME\""
        # dms restart # for now
      fi
    '';
  workspaceCmd =
    mark: name:
    "mark --add ${mark}, exec ${ensureWorkspaceScript} ${mark} ${escapeShellArg name}, move window to mark ${mark}";
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
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
          "${modifier}+Shift+r" = mkOverride 90 "reload, exec dms restart";
          "${modifier}+d" = mkOverride 90 "exec dms ipc launcher openWith all";
          "${modifier}+n" = "exec dms ipc plugins reload linuxWallpaperEngine";

          # Screenshots
          "Print" = mkOverride 90 "exec dms ipc quickCapture screenshot all";
          "Control+Print" = mkOverride 90 "exec dms ipc quickCapture screenshot region";
          # "Mod1+Print" = mkOverride 90 "exec --no-startup-id ${getExe pkgs.shutter} --active";

          # Audio
          "XF86AudioMute" = "exec dms ipc audio mute";
          "XF86AudioLowerVolume" = "exec dms ipc audio decrement 5";
          "XF86AudioRaiseVolume" = "exec dms ipc audio increment 5";
          "XF86AudioPlay" = "exec dms ipc mpris playPause";
          "XF86AudioStop" = "exec dms ipc mpris stop";
          "XF86AudioNext" = "exec dms ipc mpris next";
          "XF86AudioPrev" = "exec dms ipc mpris previous";
          "Control+XF86AudioLowerVolume" = "exec dms ipc mpris decrement 5";
          "Control+XF86AudioRaiseVolume" = "exec dms ipc mpris increment 5";

          # Display
          "XF86MonBrightnessDown" = "exec dms ipc brightness decrement 5 \"\"";
          "XF86MonBrightnessUp" = "exec dms ipc brightness increment 5 \"\"";
          # TODO: change to "dms ipc settings focusOrToggleWith displays" when sway is supported in dms
          "${modifier}+P" = "exec wdisplays";
        };
      input = {
        "type:touchpad" = {
          # tap to click, https://slar.se/configuring-touchpad-in-sway.html
          tap = "enabled"; # enables click-on-tap
          tap_button_map = "lrm"; # tap with 1 finger = left click, 2 fingers = right click, 3 fingers = middle click
          dwt = "enabled"; # disable (touchpad) while typing
          dwtp = "enabled"; # disable (touchpad) while track pointing

          natural_scroll = "enabled"; # inverted scroll
          drag_lock = "disable"; # dragging stops when lifting a finger when disabled, otherwise with another tap
        };
      };
      seat = {
        "*" = {
          # hide_cursor = "when-typing enable";
          hide_cursor = "5000"; # after 5s
        };
      };
    };
    extraConfig = ''
      blur enable
      blur_passes 3
      blur_radius 5

      shadows enable
      shadow_blur_radius 20

      smart_corner_radius on
      corner_radius 10

      default_dim_inactive 1.0
      dim_inactive_colors.unfocused #000000

      for_window {
        [title="Picture-in-Picture"] floating enable, sticky enable
        [title="Picture in picture"] floating enable, sticky enable
        [app_id="Variety" title="Variety Images"] floating enable, sticky enable
        [class="Overlayed" title="Overlayed - Main"] floating enable, sticky enable, blur disable, shadows disable
        [app_id="org.keepassxc.KeePassXC"] floating enable, sticky enable
        [app_id="teams-for-linux" floating] sticky enable, resize set 320 240, move position 5 ppt 5 ppt

        [app_id="wdisplays"] floating enable, resize set 50 ppt 50 ppt
        [class="steam" title="Friends List"] floating enable, resize set 400 800

        [app_id="Logseq"] move scratchpad, exec "${pkgs.libnotify}/bin/notify-send \\"Logseq has been moved to the scratchpad.\\""

        [class="Tockler"] no_focus

        [app_id="org.wezfurlong.wezterm"] blur_radius 10

        # Workspaces
        [app_id="fluffychat"] ${workspaceCmd "ws_comm" "Comm"}
        [class="discord"] ${workspaceCmd "ws_comm" "Comm"}
        [app_id="thunderbird"] ${workspaceCmd "ws_comm" "Comm"}
      }
    '';
  };

  home.packages = with pkgs; [
    wdisplays
  ];

  systemd.user.services.sway-inactive-windows-transparency = {
    Install.WantedBy = [ "graphical-session.target" ];
    Unit = {
      After = [ "graphical-session.target" ];
      Description = with pkgs.sway-contrib.inactive-windows-transparency.meta; "${name} - ${description}";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${getExe pkgs.sway-contrib.inactive-windows-transparency} --global-focus --focused 0.95 --opacity 0.7";
      Restart = "on-failure";
    };
  };
}
