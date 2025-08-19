{ lib, config, ... }@inputs:
let
  topBlocks = (import ./blocks/top inputs).all;
  bottomBlocks = import ./blocks/bottom inputs;
in
with lib;
{
  bars = {
    top = {
      # https://github.com/greshake/i3status-rust/blob/master/doc/themes.md#available-themes
      theme = "solarized-dark";
      settings.theme.overrides = config.lib.stylix.i3status-rust.bar;
      icons = "material-nf";
      # https://docs.rs/i3status-rs/latest/i3status_rs/blocks/index.html
      blocks = topBlocks;
    };
    bottom = {
      # https://github.com/greshake/i3status-rust/blob/master/doc/themes.md#available-themes
      theme = "solarized-dark";
      settings.theme.overrides = config.lib.stylix.i3status-rust.bar;
      icons = "material-nf";
      # https://docs.rs/i3status-rs/latest/i3status_rs/blocks/index.html
      blocks = bottomBlocks;
    };
  };
}
