{ lib
, config
, pkgs
, ...
}@args:
with lib;
let
  cfg = config.xsession.windowManager.i3;
  cfgStylix = config.stylix.targets.i3.exportedBarConfig;
  i3lib = import ./lib.nix { inherit lib config; };
  i3startup = import ./startup.nix args;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dmenu
      i3status
      # i3status-rust
      i3lock
      i3blocks
      nitrogen
      brightnessctl
      nerd-fonts.symbols-only
      speedtest-cli
      rofi-power-menu
      jq
    ];

    # https://itsfoss.com/i3-customization/
    xsession.windowManager.i3 = {
      package = pkgs.i3-gaps;
      config =
        let
          sharedConfig = import ../../../shared/i3-sway args {
            stylixBarConfig = cfgStylix;
          };
          overrideConfig = {
            modifier = "Mod4";
            gaps = {
              inner = 30;
              outer = 0;
            };
            workspaceAutoBackAndForth = true;
            window.titlebar = false;
            floating.titlebar = true;
            keybindings = mkOptionDefault (
              with i3lib;
              let
                execFirefox = pkgs.writeShellApplication {
                  name = "exec-firefox";
                  text = ''
                    pgrep --exact .firefox-wrappe || ( firefox & disown )
                    i3-msg '[class="firefox"]' focus
                  '';
                };
              in
              {
                "${modifier}+Shift+e" = "exec rofi -show power-menu";
                "${modifier}+Return" = "exec wezterm";
                "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set ${brightnessChange}+";
                "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set ${brightnessChange}-";
                "${modifier}+Ctrl+Left" = moveWorkspace "left";
                "${modifier}+Ctrl+Right" = moveWorkspace "right";
                "${modifier}+Ctrl+Up" = moveWorkspace "up";
                "${modifier}+Ctrl+Down" = moveWorkspace "down";
                "${modifier}+d" = "exec rofi -show combi";
                "${modifier}+Ctrl+E" = "exec xdg-open \"$HOME\"";
                "${modifier}+Ctrl+F" = "exec ${getExe execFirefox}";
                "${modifier}+Shift+v" = mkIf (config.services.copyq.enable) "exec ${getExe config.services.copyq.package} menu";

                # https://unix.stackexchange.com/a/439487
                "XF86AudioPlay" = "exec ${getExe pkgs.playerctl} play-pause";
                "XF86AudioStop" = "exec ${getExe pkgs.playerctl} stop";
                "XF86AudioNext" = "exec ${getExe pkgs.playerctl} next";
                "XF86AudioPrev" = "exec ${getExe pkgs.playerctl} previous";
              }
              // allWorkspaceKeyBindings
            );
            assigns = i3lib.allWorkspaceAssigns;
            defaultWorkspace =
              let
                firstWorkspace = builtins.elemAt i3lib.workspaces 0;
                firstWorkspaceIdentifier = i3lib.workspaceIdentifier firstWorkspace 1;
              in
              "workspace ${firstWorkspaceIdentifier}";
            window = {
              border = 5;
            };
            startup = i3startup;
          };
          mergedConfig = recursiveUpdate sharedConfig overrideConfig;
        in
        mergedConfig;
      extraConfig = ''
        for_window [title="Overlayed - Main"] floating enable, sticky enable
        for_window [class="Nemo"] floating enable, resize set 1280 720
        for_window [class="Logseq"] move scratchpad, exec "${pkgs.libnotify}/bin/notify-send \\"Logseq has been moved to the scratchpad.\\""
        for_window [class="copyq"] floating enable
        for_window [class="Screenkey"] floating enable, sticky enable, border none
        for_window [class="davmail-DavGateway" title="Office 365 - Manual authentication"] floating enable
        for_window [class="gnome-calculator"] floating enable
        for_window [class="KeePassXC"] floating enable
      '';
    };
  };
}
