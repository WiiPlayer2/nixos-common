{ inputs, ... }:
[
  inputs.self.nixosModules.systemdless-container
  # ({ modulesPath, ... }: {
  #   imports = [
  #     "${toString modulesPath}/virtualisation/docker-image.nix"
  #   ];
  # })

  {
    nixpkgs.hostPlatform = "x86_64-linux";
  }
]
