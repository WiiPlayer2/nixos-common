inputs: {
  imports = [
    ./hosts.nix
    ./common.nix
    (import ./domain.nix inputs)
    (import ./flake-imports.nix inputs)
  ];
}
