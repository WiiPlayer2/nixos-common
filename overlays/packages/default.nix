{ inputs, lib, ... }:
{
  flake.overlays.packages =
    let
      pkgsOverlay = import ../../pkgs/all-packages.nix {
        inherit inputs;
      };
      pkgsExtendsOverlay = import ./pkgs-extends;
      combinedOverlay = lib.fixedPoints.composeManyExtensions [
        pkgsOverlay
        pkgsExtendsOverlay
      ];
    in
    combinedOverlay;
}
