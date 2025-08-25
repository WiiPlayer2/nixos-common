{ self, ... }:
{
  flake.homeModules = {
    default = self.homeModules.all;
    all = {
      imports = [
        self.homeModules.my
        self.homeModules.extra
        self.homeModules.legacy
      ];
    };
    my = import ./my;
    extra = import ./extra;
  };
}
