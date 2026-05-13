{ inputs, ... }:
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    inputs.home-manager.nixosModules.default

    inputs.self.nixosModules.agenix-imprinting
  ];
}
