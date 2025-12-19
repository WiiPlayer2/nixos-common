{ inputs, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    inputs.self.nixosModules.security-cmd-polkit
  ];

  home-manager.sharedModules = [
    inputs.self.homeModules.profile-workstation
  ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  environment.systemPackages = with pkgs; [
    gparted
    kubevirt
  ];

  programs = {
    kdeconnect.enable = true;
    system-config-printer.enable = true;
  };

  services = {
    printing = {
      enable = true;
      startWhenNeeded = true;
      drivers = with pkgs; [
        hplipWithPlugin
      ];
    };
    system-config-printer.enable = true;
  };

  unified.hardware.wacom-tablet.enable = true;
}
