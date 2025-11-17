{ lib, pkgs }:
with lib;
{
  enable = mkEnableOption "";

  package = mkPackageOption pkgs "poptracker" {};

  packs = mkOption {
    type = with types; functionTo (listOf package);
    default = [];
  };
}
