{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.store-caching;
in
{
  options.my.features = {
    store-caching.enable = mkEnableOption "Nix store caching";
  };

  config.my = mkIf cfg.enable {
    programs.attic-client = {
      enable = true;
    };

    services.attic-watch = {
      enable = true;
    };

    # FIXME: does not work at the moment ("failed with exit code 1")
    # config.nix.settings.post-build-hook = "attic push default $OUT_PATHS";
  };
}
