{ lib, config, ... }:
with lib;
let
  cfg = config.my.meta;
  mkPkgsCheck =
    pkgs: adjective: check:
    mkIf ((length pkgs) > 0) {
      warnings =
        let
          mapPkg = pkg: "${pkg.meta.name} was desired but is ${adjective}";
          mappedPkgs = map mapPkg pkgs;
        in
        mappedPkgs;

      assertions =
        let
          mapPkg = pkg: {
            assertion = check pkg;
            message = "${pkg.meta.name} was ${adjective} but is not anymore";
          };
          mappedPkgs = map mapPkg pkgs;
        in
        mappedPkgs;
    };
  mkAllowPkgs =
    pkgs:
    mkIf ((length pkgs) > 0) {
      nixpkgs.config.permittedInsecurePackages = pkgs;
    };
in
{
  config = mkMerge [
    (mkPkgsCheck cfg.brokenPackages "broken" (x: x.meta.broken))
    (mkPkgsCheck cfg.insecurePackages "insecure" (x: x.meta.insecure))
    # (mkAllowPkgs cfg.allowedInsecurePackages)
  ];
}
