inputs: {
  imports = [
    ./nixos-compat.nix
    "${inputs.nixpkgs}/nixos/modules/config/xdg/portal.nix"
    ./dbus.nix
  ];
}
