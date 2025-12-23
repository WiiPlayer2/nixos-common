{ lib, config, ... }:
with lib;
let
  cfg = config.services.wyoming.satellite;
in
{
  options.services.wyoming.satellite = {
    openFirewall = mkOption {
      type = types.bool;
      default = true;
    };

    port = mkOption {
      type = types.port;
      default = 10700;
    };
  };

  config = mkIf cfg.enable {
    services.wyoming.satellite = {
      uri = mkDefault "tcp://0.0.0.0:${toString cfg.port}";
    };

    networking = {
      firewall.allowedTCPPorts = mkIf cfg.openFirewall [
        cfg.port
      ];
    };
  };
}
