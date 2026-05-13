{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.core-deps
    inputs.self.nixosModules.core-impl
  ];
}
