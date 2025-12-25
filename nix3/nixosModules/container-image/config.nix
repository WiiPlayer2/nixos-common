{
  lib,
  pkgs,
  config,
}:
with lib;
let
  cfg = config.containerImage;
  fullName = "${cfg.name}-${config.system.nixos.label}";
in
{
  system.build.image = pkgs.dockerTools.buildImage {
    name = cfg.name;
    tag = config.system.nixos.label;
    copyToRoot = pkgs.buildEnv {
      name = "${fullName}-root";
      paths = [
        pkgs.busybox
      ];
      postBuild = ''
        ln -sf ${config.system.build.toplevel}/activate $out/activate
        ln -sf ${cfg.entrypointScript} $out/entrypoint
        ln -sf ${cfg.entrypointActivateScript} $out/entrypoint-activate
        mkdir -p $out/tmp
      '';
    };
    config = cfg.imageConfig;
  };

  system.build.earlyMountScript = mkForce (pkgs.writeText "nop" "");

  environment.etc = {
    hostname.enable = false;
    hosts.enable = false;
  };
}
