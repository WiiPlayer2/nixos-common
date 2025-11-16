{ lib, inputs, ... }:
with lib;
{
  flake.overlays.unstable =
    final: prev:
    let
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev)
          system
          config;
      };
      refPkgs = [
        "firefoxpwa"
        "jetbrains"
        "archipelago"
        # "modemmanager"
        "poptracker"
      ];
      scopePkgs = [
        "phoc"
        # "phosh"
        # "phosh-mobile-settings"
      ];
      refPkgs' =
        genAttrs
          refPkgs
          (name: unstable.${name});
      scopePkgs' =
        genAttrs
          scopePkgs
          (name: final.callPackage unstable.${name}.override { });
    in
    refPkgs' // scopePkgs' // {
      phosh = final.callPackage unstable.phosh.override {
        inherit (unstable)
          modemmanager
          gmobile
          ;
      };
      phosh-mobile-settings = final.callPackage unstable.phosh-mobile-settings.override {
        inherit (unstable)
          modemmanager
          gmobile
          ;
      };
    };
}
