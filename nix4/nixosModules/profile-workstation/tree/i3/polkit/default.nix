{ lib, pkgs, ... }:
with lib;
let
  scriptPkg = pkgs.callPackage ./_script-package.nix { };
in
{
  security.cmd-polkit = {
    enable = true;
    mode = "serial";
    command = getExe scriptPkg;
  };
}
