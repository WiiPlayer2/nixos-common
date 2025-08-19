{ lib, ... }:
with lib;
let
  programs = [
    "ripgrep-all"
    "bat"
  ];
in
{
  programs = genAttrs programs (x: { enable = true; });
}
