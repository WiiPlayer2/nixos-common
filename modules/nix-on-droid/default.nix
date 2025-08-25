{ self, inputs, ... }:
{
  flake.nixOnDroidModules = {
    default = self.nixOnDroidModules.all;
    all = {
      imports = [
        self.nixOnDroidModules.my
        self.nixOnDroidModules.extra
        self.nixOnDroidModules.nixosCompat
        self.nixOnDroidModules.legacy
      ];
    };
    my = import ./my;
    extra = import ./extra;
    nixosCompat = import ./nixos-compat inputs;
  };
}
