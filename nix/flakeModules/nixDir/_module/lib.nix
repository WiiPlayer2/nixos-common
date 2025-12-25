{
  lib,
  haumea,
  import-tree,
  inputs,
}:
with lib;

haumea.lib.load {
  src = ./lib;
  inputs = {
    inherit inputs haumea import-tree;
    lib = extend (_: _: haumea.lib);
  };
}
