{ lib, ... }:
with lib;
let
  programs = [
    "bat"
    "ripgrep-all"
    "git"
  ];
in
{
  programs = genAttrs programs (x: { enable = true; });
}
