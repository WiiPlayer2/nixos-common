{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
    ../modules/flake/all.nix # Avoid referencing self due to infinite recursion

    ../apps
    ../devShells
    ../modules
    ../overlays
    ../pkgs
    ../templates
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
