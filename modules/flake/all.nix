inputs:
{
  imports = [
    ./home-modules.nix
    ./nix-on-droid-modules.nix
    ./hosts.nix
    ./common.nix
    (import ./domain.nix inputs)
    (import ./flake-imports.nix inputs)
  ];
}
