{ config }:
let
  cfg = config.containerImage;
in
[
  {
    assertion =
      cfg.systemdService == null
      || (config.systemd.services.${cfg.systemdService}.serviceConfig.Type or "") != "forking";
    message = "SystemD services of type forking are not supported.";
  }
]
