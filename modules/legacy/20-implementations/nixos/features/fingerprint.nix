{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.fingerprint;
in
{
  config = mkIf cfg.enable {
    services.fprintd = {
      enable = true;
    };
    security.pam.services = {
      login.fprintAuth = false;
      sudo.fprintAuth = true;
      xfce4-screensaver.fprintAuth = true;
    };
  };
}
