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
      phosh = unstable.phosh;
      phosh-mobile-settings = unstable.phosh-mobile-settings;
      # teams-for-linux = unstable.teams-for-linux;
    };
}
