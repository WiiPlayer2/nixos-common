{ lib, config, ... }:
with lib;
let
  cfg = config.my.useCase.server.k8s;
in
{
  imports = [
    ./server.nix
    ./agent.nix
  ];

  config = mkIf (cfg.server.enable || cfg.agent.enable) {
    services = {
      k3s = {
        enable = true;

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

    boot = {
      kernel.sysctl."fs.inotify.max_user_instances" = 256;
      supportedFilesystems = [ "nfs" ];
    };
  };
}
