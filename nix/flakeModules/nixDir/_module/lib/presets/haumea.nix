{
  lib,
  haumea,
  inputs,
}:
with lib;

{
  loadByAttribute = false;

  loader =
    { path, ... }:
    let
      data = haumea.lib.load {
        src = path;
        inputs = {
          inherit inputs;
          lib = extend (_: _: haumea.lib);
        };
      };
    in
    data;
}
