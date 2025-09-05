{ lib, inputs }:
let
  buildOverlay =
    { pkgsPath
    , additionalPackages ? (_: _: { })
    , additionalInput ? (_: _: { })
    ,
    }:
    final: prev:
    let
      evalPkgs = {
        inherit prev;
      } // (additionalInput final prev);

      finalPkgs = final // evalPkgs;
      prevPkgs = prev // packages // evalPkgs;
      callPackage =
        if final ? callPackage
        then prev.lib.callPackageWith finalPkgs
        else prev.lib.callPackageWith prevPkgs;

      packages' = prev.lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = pkgsPath;
      };
      additionalPackages' = additionalPackages final prev;
      packages = packages' // additionalPackages';
    in
    packages;
in
buildOverlay {
  pkgsPath = ./by-name;
  additionalInput = lib.fixedPoints.composeManyExtensions [
    inputs.poetry2nix.overlays.default
    (_: _: {
      loadPyproject = inputs.pyproject-nix.lib.project.loadPyproject;
    })
  ];
}
