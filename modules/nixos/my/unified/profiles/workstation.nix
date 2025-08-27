{ lib, config, pkgs, ... }:
with lib;
{
  options.unified.profiles.workstation.enable = mkEnableOption "";

  config = mkIf config.unified.profiles.workstation.enable {
    home-manager.sharedModules = [
      {
        unified.profiles.workstation.enable = true;
      }
    ];

    boot.binfmt.emulatedSystems = [
      "aarch64-linux"
    ];

    environment.systemPackages = with pkgs; [
      gparted
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
  };
}
