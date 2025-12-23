{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.fingerprint;
in
{
  options.security.pam.services = mkOption {
    type = types.attrsOf (
      types.submodule {
        config.fprintAuth = mkDefault true;
      }
    );
  };

  config = mkIf cfg.enable {
    services.fprintd.enable = true;
    security.pam.services.login.fprintAuth = false;
  };
}
