{ inputs, ... }:
{
  imports = [
    (import ../modules/flake/flake-imports.nix inputs) # Avoid referencing self due to infinite recursion
    ../modules/flake/common.nix # Avoid referencing self due to infinite recursion
    ../modules/flake/nixDir.nix # Avoid referencing self due to infinite recursion
    ../modules/flake/nixDir3 # Avoid referencing self due to infinite recursion
    ../modules/flake/nixDir4 # Avoid referencing self due to infinite recursion

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

  nixDir3.root = ./..;
  nixDir4.root = ./..;
}
