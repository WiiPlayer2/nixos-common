{ lib, ... }:
with lib;
let
  programs = [
    "bat"
    "ripgrep-all"
    "direnv"
  ];
in
{
  programs = genAttrs programs (x: { enable = true; });
}
