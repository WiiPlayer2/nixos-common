{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    types
    ;

  cfg = config.my.configuration;
in
{
  options.my.configuration = {
    deviceType = mkOption {
      description = "The device type of this configuration.";
      type = with types; str;
    };
    domain = mkOption {
      description = "The domain of this configuration.";
      type = with types; str;
    };
    hardware = mkOption {
      description = "The hardware of this configuration.";
      type = with types; nullOr str;
      default = null;
    };
    roles = mkOption {
      description = "The roles of this configuration.";
      type = with types; listOf str;
    };
  };

  config.assertions = [
    {
      assertion = cfg ? domain;
      message = "Configuration domain must be set.";
    }
  ];
}
