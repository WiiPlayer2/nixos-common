inputs:
{ lib, ... }:
let
  nixDirLib = import ../../nix/flakeModules/nixDir/_module/lib.nix {
    inherit lib inputs;
    inherit (inputs) haumea import-tree;
  };

  loadNixDirModule =
    name:
    nixDirLib.loaders.modules {
      path = ../../nix/flakeModules/${name};
    };
in
{
  imports = [
    ./home-modules.nix
    ./nix-on-droid-modules.nix
    (loadNixDirModule "nixDir")
  ];

  perSystem =
    {
      inputs',
      self',
      lib,
      pkgs,
      ...
    }:
    {
      formatter = inputs'.nixpkgs-unstable.legacyPackages.nixfmt-tree;
      pre-commit.settings.hooks.nixfmt.enable = true;
    };
}
