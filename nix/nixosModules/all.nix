{ self, ... }:
{
  imports = [
    self.nixosModules.my
    self.nixosModules.extra
    self.nixosModules.legacy
    self.nixosModules.home-manager-nonroot-modules
  ];
}
