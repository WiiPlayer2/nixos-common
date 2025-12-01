{ lib, pkgs }:
with lib;
{
  enable = mkEnableOption "";

  package = mkPackageOption pkgs "bizhawk" { };

  prefixCommand = mkOption {
    type =
      with types;
      nullOr str
      // {
        merge =
          loc: defs:
          let
            definedPrefixes = filter (x: x != null) (map (x: x.value) defs);
            prefix = join " " definedPrefixes;
          in
          if definedPrefixes == [ ] then null else prefix;
      };
    default = null;
  };
}
