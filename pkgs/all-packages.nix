{ inputs }:
final: prev:
let
  additionalPkgsOverlay = prev.lib.fixedPoints.composeManyExtensions [
    inputs.poetry2nix.overlays.default
    (_: _: {
      loadPyproject = inputs.pyproject-nix.lib.project.loadPyproject;
    })
  ];

  prev' = prev.extend additionalPkgsOverlay;

  final' =
    if final ? extend
    then final.extend additionalPkgsOverlay
    else final;

  callPackage = final'.callPackage or (prev.lib.callPackageWith (prev' // packages));

  packages = prev.lib.packagesFromDirectoryRecursive {
    inherit callPackage;
    directory = ./by-name;
  };
in
packages
