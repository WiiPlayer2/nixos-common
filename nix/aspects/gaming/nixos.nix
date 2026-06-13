{ inputs, ... }:
{ lib, pkgs, ... }:
with lib;
{
  imports = [
    inputs.self.nixosModules.programs-gamemode
  ];

  environment.systemPackages = with pkgs; [
    yad
    xwininfo
    wget
    xdotool
    pince
  ];

  programs.steam = {
    protontricks.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      steamtinkerlaunch
    ];
  };
}
