{ lib, ... }:
with lib;
let
  programs = [
    "bat"
    "ripgrep-all"
  ];
in
{
  programs = genAttrs programs (x: { enable = true; });
}
