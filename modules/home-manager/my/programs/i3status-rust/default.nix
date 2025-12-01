# TODO: this all needs refactoring
{
  lib,
  config,
  pkgs,
  ...
}@args:
with lib;
let
  cfg = config.programs.i3status-rust;
  i3status-rust = import ./i3status-rust.nix args;
in
{
  imports = [
    ./blocks/default-blocks.nix
    ./blocks/pomodoro.nix
  ];

  programs.i3status-rust = {
    enable = config.xsession.windowManager.i3.enable || config.wayland.windowManager.sway.enable;
    bars = i3status-rust.bars;
  };
}
