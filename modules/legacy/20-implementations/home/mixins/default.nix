{ lib, ... }:
with lib;
{
  imports = map (x: ./${x.name}) (
    filter (x: x.name != "default.nix") (attrsToList (builtins.readDir ./.))
  );
}
