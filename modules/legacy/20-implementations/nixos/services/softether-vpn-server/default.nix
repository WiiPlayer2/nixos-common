{ lib, config, ... }@args:
with lib;
let
  inherit (import ./_lib.nix args)
    softetherConfigurationTypes
    createConfigGenerationService
    ;
  cfg = config.my.services.softether-vpn-server;
in
{
  options.services.softether = {
    vpnserver = {
      manageConfig = mkEnableOption "Manage configuration";
      config = mkOption {
        description = "Configuration for SoftEther VPN server";
        type = softetherConfigurationTypes.section;
        default = { };
      };
    };
    vpnbridge = {
      manageConfig = mkEnableOption "Manage configuration";
      config = mkOption {
        description = "Configuration for SoftEther VPN bridge";
        type = softetherConfigurationTypes.section;
        default = { };
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.softether = {
        enable = true;
        vpnbridge = {
          enable = false;
          config = import ./config-bridge.nix cfg;
        };
        vpnserver = {
          enable = true;
          config = import ./config-server.nix cfg;
        };
      };

      networking.firewall = {
        allowedTCPPorts = [
          443
          992
          1194
          5555
        ];
        allowedUDPPorts = [
          1194
        ];
      };
    })
    (mkIf
      (config.services.softether.vpnserver.enable && config.services.softether.vpnserver.manageConfig)
      {
        systemd.services.softether-vpnserver-config = createConfigGenerationService {
          component = "vpnserver";
          description = "VPN server";
          configFile = "vpn_server.config";
        };
      }
    )
    (mkIf
      (config.services.softether.vpnbridge.enable && config.services.softether.vpnbridge.manageConfig)
      {
        systemd.services.softether-vpnbridge-config = createConfigGenerationService {
          component = "vpnbridge";
          description = "VPN bridge";
          configFile = "vpn_bridge.config";
        };
      }
    )
  ];
}
