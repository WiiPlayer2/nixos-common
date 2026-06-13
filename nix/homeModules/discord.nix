# TODO: maybe put into a themed module ¯\_(ツ)_/¯
{ ... }:
{ config, ... }:
{
  programs.discord = {
    enable = true;
  };

  xdg.autostart.entries = [
    "${config.programs.discord.package}/share/applications/discord.desktop"
  ];
}
