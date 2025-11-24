{ inputs, modulesPath }:
[
  inputs.self.nixosModules.s6-systemd-shim
  "${toString modulesPath}/virtualisation/docker-image.nix"
]
