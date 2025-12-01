{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.boot;
in
{
  config = mkMerge [
    (mkIf cfg.secureboot.enable {
      environment.systemPackages = with pkgs; [
        sbctl
      ];

      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
        configurationLimit = 30;
      };
    })
    (mkIf cfg.splash.enable {
      stylix.targets.plymouth.enable = false;
      boot.plymouth.enable = true;
    })
    {
      boot = {
        binfmt = {
          emulatedSystems = cfg.binfmt.emulatedSystems;
          preferStaticEmulators = true;
        };
      };
    }
  ];
}
