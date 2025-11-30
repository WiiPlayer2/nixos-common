{ pkgs, config }:
let
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
        config.system.build.toplevel
        pkgs.stdenv
      ];
    };
  };
}
