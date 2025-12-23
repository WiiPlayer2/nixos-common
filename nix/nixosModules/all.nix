{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.my
    inputs.self.nixosModules.extra
    inputs.self.nixosModules.legacy
  ];
}
