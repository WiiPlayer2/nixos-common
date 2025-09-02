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
      teams-for-linux = unstable.teams-for-linux;
    };
}
