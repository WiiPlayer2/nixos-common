{ lib, config, pkgs, hostConfig, ... }:
with lib;
let
  cfg = config.services.xserver.desktopManager.phosh;
in
{
  config = mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      xserver = {
        enable = true;
        desktopManager.phosh = {
          user = hostConfig.mainUser;
          group = config.users.users.${hostConfig.mainUser}.group;
          phocConfig.xwayland = "true";
        };
      };
    };

    systemd.services.display-manager.serviceConfig = {
      SuccessExitStatus = "SUCCESS 23";
      Restart = mkForce "no";
    };

    environment.systemPackages = with pkgs; [
      phosh-mobile-settings
    ];
  };
}
