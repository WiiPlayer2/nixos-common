{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.styling-deps
    inputs.self.nixosModules.styling-impl
  ];
}
