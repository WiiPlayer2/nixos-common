{ inputs, ... }:
{
  flake.homeModules = {
    my = import ./my;
    extra = import ./extra;
  };
}
