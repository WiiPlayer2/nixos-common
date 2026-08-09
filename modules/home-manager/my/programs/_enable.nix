{ lib, ... }:
with lib;
let
  programs = [
    "direnv"
  ];
in
{
  programs = genAttrs programs (x: {
    enable = true;
  });
}
