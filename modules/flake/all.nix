inputs:
{
  imports = [
    ./home-modules.nix
    ./nix-on-droid-modules.nix
    ./hosts.nix
    (import ./my.nix inputs)
  ];
}
