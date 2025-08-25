{ self, ... }:
{
  flake.nixosModules = {
    default = self.nixosModules.all;
    all = {
      imports = [
        self.nixosModules.my
        self.nixosModules.extra
        self.nixosModules.legacy
      ];
    };
    my = import ./my;
    extra = import ./extra;
  };
}
