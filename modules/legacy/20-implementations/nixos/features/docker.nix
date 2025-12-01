{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.features.docker;
  mainUser = config.my.config.mainUser.name;
in
{
  config = mkMerge [
    (mkIf (cfg.enable && cfg.runtime == "docker") {
      virtualisation.docker.enable = true;

      users.users.${mainUser}.extraGroups = [
        "docker"
      ];
    })
    (mkIf (cfg.enable && cfg.runtime == "podman") {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        autoPrune.enable = true;
      };

      environment.systemPackages = with pkgs; [
        podman-compose
      ];

      users.users.${mainUser}.extraGroups = [
        "podman"
      ];
    })
  ];
}
