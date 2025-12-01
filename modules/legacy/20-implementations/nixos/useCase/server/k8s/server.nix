{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.useCase.server.k8s.server;
in
{
  config = mkIf cfg.enable {
    services = {
      k3s = {
        role = "server";
        inherit (cfg)
          tokenFile
          ;
        configPath = ./k3s-config.yaml;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        6443 # kube apiserver
        10250 # kubelet HTTPS metrics
        10255 # kubelet HTTP metrics
        4194 # kubelet cadvisor
      ]
      ++ cfg.allowedPorts.tcp;
      allowedUDPPorts = [
        8472 # flannel VXLAN
      ]
      ++ cfg.allowedPorts.udp;
    };
  };
}
