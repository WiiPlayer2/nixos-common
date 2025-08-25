{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.docker;
in
{
  options.my.features.docker = {
    enable = mkEnableOption "Docker";
    runtime = mkOption {
      description = "The container runtime to use";
      type = types.enum [
        "docker"
        "podman"
      ];
      default = "podman";
    };
  };

  config.my = mkMerge [
    (mkIf cfg.enable {
      # docker daemon
    })
  ];
}
