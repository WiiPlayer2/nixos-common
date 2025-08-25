{ self, inputs, ... }:
{
  flake.flakeModules = {
    default = self.flakeModules.all;
    all = import ./all.nix inputs;
    homeModules = ./home-modules.nix;
    hosts = ./hosts.nix;
    my = import ./my.nix inputs;
  };
}
