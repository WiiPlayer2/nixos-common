{ lib, pkgs }:
with lib;
{
  enable = mkEnableOption "";

  package = mkPackageOption pkgs "dolphin-emu" { };

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

  prefixEnvironmentVariables = mkOption {
    type = with types; attrsOf str;
    default = { };
  };

  additionalVariants = mkOption {
    type = with types; listOf package;
    default = [ ];
  };
}
