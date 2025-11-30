{ lib, pkgs, config }:
with lib;
let
  cfg = config.containerImage;
  name = "nixos-oci-container-${config.system.name}";
  fullName = "${name}-${config.system.nixos.label}";
in
{
  system.build.image = pkgs.dockerTools.buildImage {
    inherit name;

    tag = config.system.nixos.label;
    copyToRoot = pkgs.buildEnv {
      name = "${fullName}-root";
      paths = [
        pkgs.busybox
      ];
      pathsToLink = [
        "/bin"
      ];
    };
    config = cfg.imageConfig;
  };

  system.build.earlyMountScript = mkForce (pkgs.writeText "nop" "");

  environment.etc = {
    hostname.enable = false;
    hosts.enable = false;
  };
}
