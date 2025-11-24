{ lib, config }:
with lib;
let
  enabledSystemdServices =
    filterAttrs
      (_: v: v.enable)
      config.systemd.services;
  mkS6Shim =
    name:
    service:
    { };
  s6Services =
    mapAttrs
      mkS6Shim
      enabledSystemdServices;
in
# s6Services
break { }
