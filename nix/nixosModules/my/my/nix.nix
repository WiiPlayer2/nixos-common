{ pkgs, ... }:
let
  lixPackageSet = pkgs: pkgs.lixPackageSets.latest;
in
{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (lixPackageSet prev)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena;
    })
  ];

  nix = {
    package = (lixPackageSet pkgs).lix;
    settings = {
      builders-use-substitutes = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 15d";
    };
  };
}
