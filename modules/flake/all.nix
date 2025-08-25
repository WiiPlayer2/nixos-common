inputs:
{
  imports = [
    ./home-modules.nix
    ./hosts.nix
    (import ./my.nix inputs)
  ];
}
