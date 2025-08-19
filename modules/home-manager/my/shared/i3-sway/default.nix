{ lib, config, pkgs, ... }:
with lib;
let
  mkBarConfig = {}: { };
  mkConfig =
    { stylixBarConfig }:
    {
      bars = [
        (
          {
            # command = "${pkgs.i3}/bin/i3bar -t";
            # command = "${pkgs.i3}/bin/i3bar";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
            position = "top";
            trayPadding = 1;
            # extraConfig = ''
            #   padding 0 0 0 1px
            # '';
          }
          // stylixBarConfig
          // {
            # colors.background = "#00000000";
            fonts = stylixBarConfig.fonts // {
              names = stylixBarConfig.fonts.names ++ [
                "Symbols Nerd Font"
              ];
            };
          }
        )
        # TODO do better also only if bottom block are available
        (
          {
            # command = "${pkgs.i3}/bin/i3bar -t";
            # command = "${pkgs.i3}/bin/i3bar";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
            position = "bottom";
            workspaceButtons = false;
            trayOutput = "none";
            # extraConfig = ''
            #   padding 0 0 0 1px
            # '';
          }
          // stylixBarConfig
          // {
            # colors.background = "#00000000";
            fonts = stylixBarConfig.fonts // {
              names = stylixBarConfig.fonts.names ++ [
                "Symbols Nerd Font"
              ];
            };
          }
        )
      ];
    };
in
mkConfig
