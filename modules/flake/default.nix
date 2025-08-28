{ self, inputs, ... }:
{
  flake.flakeModules = {
    default = self.flakeModules.all;
    all = import ./all.nix inputs;

    flakeImports = import ./flake-imports.nix inputs;
    homeModules = ./home-modules.nix;
    nixOnDroidModules = ./nix-on-droid-modules.nix;
    hosts = ./hosts.nix;
    domain = import ./domain.nix inputs;
    common = ./common.nix;
  };
}
