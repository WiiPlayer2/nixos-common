{ inputs, ... }:
{
  flake.overlays.unstable =
    final: prev:
    let
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev)
          system
          config;
      };
    in
    {
      jetbrains = unstable.jetbrains;
      phoc = final.callPackage unstable.phoc.override { };
      phosh = final.callPackage unstable.phosh.override { };
      phosh-mobile-settings = final.callPackage unstable.phosh-mobile-settings.override { };
      # teams-for-linux = unstable.teams-for-linux;
    };
}
