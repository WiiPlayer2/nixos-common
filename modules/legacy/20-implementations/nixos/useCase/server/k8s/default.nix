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
    services.k3s = {
      enable = true;
    };
  };
}
