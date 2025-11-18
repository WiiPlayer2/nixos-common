{ lib, pkgs }:
with lib;
{
  enable = mkEnableOption "";

  package = mkPackageOption pkgs "archipelago" {};

  worlds = mkOption {
    type = with types; listOf package;
    default = [];
  };

  worldPkgs = mkOption {
    type = with types; attrsOf package;
    readOnly = true;
  };
}
