{ inputs, ... }:
{
  flake.nixOnDroidModules = {
    my = import ./my;
    extra = import ./extra;
    nixosCompat = import ./nixos-compat inputs;
  };
}
