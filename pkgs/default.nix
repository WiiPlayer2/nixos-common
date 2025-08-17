{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      packages = import ./all-packages.nix
        {
          inherit inputs;
        }
        { }
        pkgs; # TODO: final should probably not be {}
    in
    {
      legacyPackages = packages;

      # Needed for updates with nix-update
      packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    };
}
