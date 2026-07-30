{ inputs, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.winapps;
  sizeType = types.strMatching "[[:digit:]]+[KMGT]?";
in
{
  options.services.winapps = {
    enable = mkEnableOption "";
    windowsVersion = mkOption {
      type = types.str;
      description = ''
        Version of Windows to configure. For valid options, visit:
        https://github.com/dockur/windows?tab=readme-ov-file#how-do-i-select-the-windows-version
        https://github.com/dockur/windows?tab=readme-ov-file#how-do-i-install-a-custom-image
      '';
      default = "11";
    };
    ramSize = mkOption {
      type = sizeType;
      default = "4G";
    };
    cpuCores = mkOption {
      type = types.ints.positive;
      default = 1;
    };
    diskSize = mkOption {
      type = sizeType;
      default = "64G";
    };
    windowsUsername = mkOption {
      type = types.str;
      default = cfg.user;
    };
    windowsPassword = mkOption {
      type = types.str;
      default = "winapps";
    };
    user = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      with inputs.winapps.packages.${stdenv.hostPlatform.system};
      [
        winapps
        winapps-launcher
      ];

    # https://github.com/winapps-org/winapps/blob/main/compose.yaml
    virtualisation.oci-containers.containers.WinApps = {
      serviceName = "winapps";
      autoStart = false;
      autoRemoveOnStop = false;

      image = "ghcr.io/dockur/windows:latest";
      environment = {
        VERSION = cfg.windowsVersion;
        RAM_SIZE = cfg.ramSize;
        CPU_CORES = toString cfg.cpuCores;
        DISK_SIZE = cfg.diskSize;
        USERNAME = cfg.windowsUsername;
        PASSWORD = cfg.windowsPassword;
        HOME = config.users.users.${cfg.user}.home;
      };
      ports = [
        "127.0.0.1:8006:8006"
        "127.0.0.1:3389:3389/tcp"
        "127.0.0.1:3389:3389/udp"
      ];
      capabilities = {
        NET_ADMIN = true;
      };
      extraOptions = [
        # "stop_grace_period: 120s"
        "--restart=on-failure"
      ];
      volumes = [
        "winapps-data:/storage"
        "${config.virtualisation.oci-containers.containers.WinApps.environment.HOME}:/shared"
        "${inputs.winapps}/oem:/oem:ro"
      ];
      devices = [
        "/dev/kvm"
        "/dev/net/tun"
      ];
    };

    systemd = {
      services.winapps.preStart = ''
        ${config.virtualisation.oci-containers.backend} volume create winapps-data
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [ 3389 ];
      allowedUDPPorts = [ 3389 ];
    };
  };
}
