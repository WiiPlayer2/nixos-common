{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      packages = import ./all-packages.nix
        {
          inherit lib inputs;
        }
        (pkgs // packages)
        pkgs;
    in
    {
      legacyPackages = packages;

      # Needed for updates with nix-update
      packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    };
}
