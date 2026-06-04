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

        [app_id="wdisplays"] floating enable

        [app_id="Logseq"] move scratchpad, exec "${pkgs.libnotify}/bin/notify-send \\"Logseq has been moved to the scratchpad.\\""

        [class="Tockler"] no_focus
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
