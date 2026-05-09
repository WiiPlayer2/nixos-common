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
  };
}
