{ lib, config, pkgs, ... }:
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
  };
}
