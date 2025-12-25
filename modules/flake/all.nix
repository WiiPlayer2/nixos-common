inputs: {
  imports = [
    ./hosts.nix
    (import ./common.nix inputs)
    (import ./domain.nix inputs)
    (import ./flake-imports.nix inputs)
  ];
}
