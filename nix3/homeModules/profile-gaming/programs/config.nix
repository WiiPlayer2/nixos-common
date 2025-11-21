{ lib, pkgs }:
with lib;
{
  poptracker.enable = true;
  archipelago.enable = true;
  dolphin-emu = {
    enable = true;
    prefixCommand = "${getExe pkgs.ludusavi} wrap --name Dolphin --gui --force --no-force-cloud-conflict -- ${getExe pkgs.gamemode}";
    additionalVariants = with pkgs; [
      dolphin-emu-primehack
    ];
  };
}
