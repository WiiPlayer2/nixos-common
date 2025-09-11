{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.my.useCase.server.k8s.agent;
in
{
  config = mkIf cfg.enable {
    services = {
      k3s = {
        role = "agent";
        inherit (cfg)
          serverAddr
          tokenFile
          ;

        package = pkgs.unstable.k3s;

        gracefulNodeShutdown = {
          enable = true;
          # default is 30s/10s
          shutdownGracePeriod = "2m";
          shutdownGracePeriodCriticalPods = "30s";
        };

        extraKubeletConfig = {
          featureGates = {
            MutatingAdmissionPolicy = true;
          };
        };

        extraFlags = [
          "--nonroot-devices"
        ];
      };

      multipath = {
        enable = true;
        defaults = ''
          user_friendly_names yes
          find_multipaths yes
        '';
        pathGroups = [ ];
      };

      openiscsi = {
        enable = true;
        name = "iqn.2020-08.org.linux-iscsi.initiatorhost:${config.my.config.hostname}";
      };
    };

    system.activationScripts.k3s-symlinks.text = ''
      ln -fs ${config.services.openiscsi.package}/bin/iscsiadm /usr/bin/iscsiadm
    '';

    systemd.tmpfiles.settings = {
      "50-k3s" =
        let
          mkSymlink = target: source: {
            name = target;
            value.L.argument = source;
          };
          mkCniLink = name: mkSymlink "/opt/cni/bin/${name}" "/var/lib/rancher/k3s/data/current/bin/cni";
          cniLinks = map mkCniLink [
            "loopback"
            "bridge"
            "host-local"
            "portmap"
          ];
          binLinks = [
            # (mkSymlink "${config.services.openiscsi.package}/bin/iscsiadm" "/usr/bin/iscsiadm") # store in path is not supported
          ];
          links = cniLinks ++ binLinks;
          tmpfiles = listToAttrs links;
        in
        tmpfiles
        // {
          "/usr/src".d = { };
        };
    };

    networking.firewall = {
      allowedTCPPorts = [
        10250 # kubelet HTTPS metrics
        10255 # kubelet HTTP metrics
        4194 # kubelet cadvisor
      ] ++ cfg.allowedPorts.tcp;
      allowedUDPPorts = [
        8472 # flannel VXLAN
      ] ++ cfg.allowedPorts.udp;
    };

    boot = {
      kernel.sysctl."fs.inotify.max_user_instances" = 256;
      supportedFilesystems = [ "nfs" ];
    };
  };
}
