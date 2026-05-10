{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.agenix-imprinting
    inputs.self.nixosModules.core-legacy
  ];
}
