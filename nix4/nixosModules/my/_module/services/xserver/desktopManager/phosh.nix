{
  lib,
  config,
  pkgs,
  hostConfig,
  ...
}:
with lib;
let
  cfg = config.services.xserver.desktopManager.phosh;
in
{
  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        desktopManager.phosh = {
          user = hostConfig.mainUser;
          group = config.users.users.${hostConfig.mainUser}.group;
          phocConfig.xwayland = "true";
        };
      };
      displayManager = {
        defaultSession = "phosh";
        autoLogin = {
          enable = true;
          user = hostConfig.mainUser;
        };
        sddm = {
          enable = true;
          wayland.enable = true;
          autoLogin.relogin = true;
        };
      };
      gnome = {
        core-apps.enable = true;
      };
    };

    systemd.services.phosh.enable = false;

    environment.systemPackages = with pkgs; [
      phosh-mobile-settings
    ];
  };
}
