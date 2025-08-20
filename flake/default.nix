{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule

    ../apps
    ../devShells
    ../modules
    ../overlays
    ../pkgs
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem =
    { inputs', self', lib, pkgs, ... }:
    {
      formatter = inputs'.nixpkgs-unstable.legacyPackages.nixfmt-tree;
      pre-commit.settings.hooks.nixpkgs-fmt.enable = true;
    };
}
