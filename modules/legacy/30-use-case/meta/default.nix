{ pkgs
, lib
, config
, ...
}:
with lib;
let
  mkPkgsOption =
    description:
    mkOption {
      inherit description;
      type = with types; listOf package;
      default = [ ];
    };
  mkAllowedPkgsOption =
    description:
    mkOption {
      inherit description;
      type = with types; listOf str;
      default = [ ];
    };
in
{
  options.my.meta = {
    configurationNames = {
      nixos = mkOption {
        description = "The configuration name of the nixos configuration";
        type = types.str;
      };
      homeManager = mkOption {
        description = "The configuration name of the home-manager configuration";
        type = types.str;
      };
      nixOnDroid = mkOption {
        description = "The configuration name of the home-manager configuration";
        type = types.str;
      };
    };
    configurationDirectory = mkOption {
      description = "The directory where the configuration flake is located";
      type = types.str;
    };
    brokenPackages = mkPkgsOption "The list of broken packages wanted to be installed.";
    insecurePackages = mkPkgsOption "The list of insecure packages wanted to be installed.";
    allowedInsecurePackages = mkAllowedPkgsOption "The list of insecure packages allowed to be installed.";
  };
}
