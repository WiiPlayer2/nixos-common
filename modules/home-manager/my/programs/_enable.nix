{ lib, ... }:
with lib;
let
  programs = [
    "bat"
    "ripgrep-all"
    "git"
    "ssh"
    "direnv"
  ];
in
{
  programs = genAttrs programs (x: { enable = true; });
}
