{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.gitea;
in
{
  config = mkIf cfg.enable {
    services.gitea = {
      enable = true;
      lfs.enable = true;

      # Make following entries configurable
      stateDir = "/storage/gitea";
      settings = {
        server = {
          DOMAIN = "ggj-server";
          OFFLINE_MODE = false;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      3000
    ];
  };
}
