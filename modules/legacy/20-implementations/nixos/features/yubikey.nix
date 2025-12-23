{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.yubikey;
in
{
  options.security.pam.services = mkOption {
    type = types.attrsOf (
      types.submodule {
        config.u2fAuth = mkDefault true;
      }
    );
  };

  # https://nixos.wiki/wiki/Yubikey
  config = mkIf cfg.enable {
    services.pcscd.enable = true;
    security.pam = {
      u2f.settings.cue = true;
      services.login.u2fAuth = false;
    };
  };
}
