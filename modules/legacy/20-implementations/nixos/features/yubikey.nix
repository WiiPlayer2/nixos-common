{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.yubikey;
in
{
  # https://nixos.wiki/wiki/Yubikey
  config = mkIf cfg.enable {
    services.pcscd.enable = true;
    security.pam = {
      u2f.settings.cue = true;

      services = {
        login.u2fAuth = false;
        sudo.u2fAuth = true;
        xfce4-screensaver.u2fAuth = true;
        polkit-1.u2fAuth = true;
      };
    };
  };
}
