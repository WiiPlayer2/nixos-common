{ lib, ... }:
with lib;
{
  # xdg.autostart.enable = mkForce false;
  services.xserver.desktopManager.runXdgAutostartIfNone = false;
}
