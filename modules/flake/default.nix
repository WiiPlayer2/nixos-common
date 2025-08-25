{ self, ... }:
{
  flake.flakeModules = {
    default = self.flakeModules.all;
    all = ./all.nix;
    homeModules = ./home-modules.nix;
    hosts = ./hosts.nix;
  };
}
