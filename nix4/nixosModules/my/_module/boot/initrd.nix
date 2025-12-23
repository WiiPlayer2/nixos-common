{ lib, config, ... }:
with lib;
let
  cfg = config.boot.initrd;
in
{
  config = mkIf cfg.clevis.enable {
    environment.systemPackages = [ cfg.clevis.package ];
  };
}
