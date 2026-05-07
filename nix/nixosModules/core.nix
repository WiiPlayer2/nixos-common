{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.core-legacy
  ];
}
