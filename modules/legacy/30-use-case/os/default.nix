{ pkgs
, lib
, config
, ...
}:
with lib;
{
  options.my.os = with lib; {
    type = mkOption {
      description = "Defines the type of OS this configuration is running on.";
      type = types.enum [
        "nixos"
        "nix-on-droid"
        "unknown"
      ];
      default = "nixos";
    };

    isHomeManagerStandalone = mkEnableOption "Defines whether home-manager is used as a standalone tool.";

    # TODO os might not be the right location for this configuration
    dualBoot = {
      enable = mkEnableOption "Whether this system has a dual boot configuration";
      uefi = {
        current = mkOption {
          description = "The UEFI id of the current boot entry";
          type = types.str;
        };
        named = mkOption {
          description = "The UEFI ids for named entries which can be booted.";
          type = with types; attrsOf str;
        };
        extra = mkOption {
          description = "The extra UEFI ids for boot selection.";
          type = with types; listOf str;
        };
      };
    };

    mounts = mkOption {
      description = "Configured mount points";
      type =
        with types;
        attrsOf (submodule {
          options = {
            enable = mkOption {
              description = "Enable this mount point";
              type = bool;
              default = true;
            };
            device = mkOption {
              description = "The device to mount";
              type = str;
            };
            type = mkOption {
              description = "The type of the device";
              type = nullOr str;
              default = null;
            };
            options = mkOption {
              description = "The mount options";
              type = nullOr (listOf str);
              default = null;
            };
          };
        });
      default = { };
    };
  };
}
