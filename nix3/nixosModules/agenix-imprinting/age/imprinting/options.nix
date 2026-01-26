{ lib, pkgs }:
with lib;
{
  enable = mkEnableOption "";

  manual = mkEnableOption "";

  target = mkOption {
    type = types.path;
  };

  imprintingFile = mkOption {
    type = types.path;
  };

  imprintingIdentityFile = mkOption {
    type = with types; nullOr path;
    default = null;
  };

  plugins = mkOption {
    type = with types; listOf package;
    default = [
      pkgs.age-plugin-amnesia
    ];
  };
}
