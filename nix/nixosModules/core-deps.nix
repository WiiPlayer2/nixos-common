{ inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.default

    inputs.self.nixosModules.agenix-imprinting
  ];
}
