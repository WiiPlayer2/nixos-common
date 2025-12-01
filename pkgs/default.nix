{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    with lib;
    let
      packages' = import ./all-packages.nix {
        inherit lib inputs;
      } (pkgs // packages') pkgs;
      packages = filterAttrs (
        n: v:
        let
          isSystemSupported = elem system (v.meta.platforms or [ system ]);
          isBroken =
            if v.meta.broken or false then
              warn "${v.name} is marked as broken and removed from packages" true
            else
              false;
        in
        isSystemSupported && !isBroken
      ) packages';
    in
    {
      legacyPackages = packages;

      # Needed for updates with nix-update
      packages = lib.filterAttrs (n: v: lib.isDerivation v) packages;
    };
}
