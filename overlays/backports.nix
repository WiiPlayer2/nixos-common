{ lib, inputs, ... }:
with lib;
let
  backports = [
    (port "nixpkgs-unstable-small" "freecad" "1.1.1")
    (port "nixpkgs-unstable-small" "bottles" "64.1")
  ];

  port =
    inputName: pkgName: pinnedVersion: prev:
    let
      pkg = inputs.${inputName}.legacyPackages.${prev.stdenv.hostPlatform.system}.${pkgName};
      currentVersion = prev.${pkgName}.version;
      portedVersion = pkg.version;
      checkedPkg =
        if versionOlder pinnedVersion currentVersion then
          throw "Package ${pkgName} was backported from ${inputName} from version ${pinnedVersion} but nixpkgs now ships ${currentVersion}."
        else if versionOlder pinnedVersion portedVersion then
          warn "Package ${pkgName} is being backported from ${inputName} from version ${pinnedVersion} but it's now on ${portedVersion}." pkg
        else
          pkg;
    in
    {
      name = pkgName;
      value = checkedPkg;
    };

  portedPkgs = prev: listToAttrs (map (x: x prev) backports);
in
{
  flake.overlays.backports = _: portedPkgs;
}
