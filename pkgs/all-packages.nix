{ lib, inputs }:
let
  buildOverlay =
    { pkgsPath
    , additionalPackages ? (_: _: { })
    , additionalInput ? (_: _: { })
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

  overridePython =
    pkgs: prevPython:
    let
      python =
        let
          overriddenPython = (prevPython.override {
            self = python;
            packageOverrides = buildOverlay {
              pkgsPath = ./python-pkgs;
            };
          });
          withPassthru = overriddenPython // {
            passthru = overriddenPython.passthru // {
              skipUpdate = true;
            };
          };
        in
        withPassthru;
    in
    python;
in
buildOverlay {
  pkgsPath = ./by-name;
  additionalInput = lib.fixedPoints.composeManyExtensions [
    inputs.poetry2nix.overlays.default
    (_: prev: {
      ninelore-monoflake = inputs.ninelore-monoflake.legacyPackages.${prev.system};
      ninelore-monoflake-pkgs = inputs.ninelore-monoflake.inputs.nixpkgs.legacyPackages.${prev.system};
      loadPyproject = inputs.pyproject-nix.lib.project.loadPyproject;
    })
  ];
  additionalPackages = final: prev: {
    python3 = overridePython final prev.python3;
  };
}
