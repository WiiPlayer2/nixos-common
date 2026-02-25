{ inputs, ... }:
{
  imports = [
    (import ../modules/flake/flake-imports.nix inputs) # Avoid referencing self due to infinite recursion
    (import ../modules/flake/common.nix inputs) # Avoid referencing self due to infinite recursion
    ../modules/flake/nixDir3 # Avoid referencing self due to infinite recursion

    ../apps
    ../devShells
    ../modules
    ../overlays
    ../pkgs

    (inputs.import-tree ./_tree)
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  nixDir.root = ./..;
  nixDir3.root = ./..;

  flake.ociImages = {
    test = inputs.self.lib.ociImages.ociImage {
      name = "test";
    };
  };
}
