{ lib, pkgs, ... }:
with lib;
{
  user.shell = getExe pkgs.zsh;
}
