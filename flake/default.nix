{ lib, inputs, ... }:
let
  nixDirLib = import ../nix/flakeModules/nixDir/_module/lib.nix {
    inherit lib inputs;
    inherit (inputs) haumea import-tree;
  };

  loadNixDirModule =
    name:
    (nixDirLib.loaders.modules { }).loader {
      path = ../nix/flakeModules/${name};
    };
in
{
  imports = [
    (import ../modules/flake/flake-imports.nix inputs) # Avoid referencing self due to infinite recursion
    ../modules/flake/common.nix # Avoid referencing self due to infinite recursion
    (loadNixDirModule "nixDir")
    ../modules/flake/nixDir3 # Avoid referencing self due to infinite recursion

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

  nixDir.root = ./..;
  nixDir3.root = ./..;
}
