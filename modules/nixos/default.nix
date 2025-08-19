{ inputs, ... }:
{
  flake.nixosModules = {
    my = import ./my;
    extra = import ./extra;
  };
}
