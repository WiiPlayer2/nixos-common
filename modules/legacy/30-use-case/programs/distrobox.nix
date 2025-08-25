{ lib, ... }:
with lib;
{
  options.my.programs.distrobox = {
    enable = mkEnableOption "Distrobox";
    manifests = mkOption {
      description = "Manifests";
      type =
        with types;
        attrsOf (submodule {
          options = {
            enable = mkOption {
              description = "Whether this manifest is enabled";
              type = types.bool;
              default = true;
            };
            config =
              let
                mkStringConfig =
                  description:
                  mkOption {
                    inherit description;
                    type = with types; nullOr str;
                    default = null;
                  };
                mkStringListConfig =
                  description:
                  mkOption {
                    inherit description;
                    type = with types; nullOr (listOf str);
                    default = null;
                  };
                mkBoolConfig =
                  description:
                  mkOption {
                    inherit description;
                    type = with types; nullOr bool;
                    default = null;
                  };
              in
              {
                image = mkOption {
                  description = "Image";
                  type = types.str;
                };
                additional_packages = mkStringListConfig "Additional packages";
                init_hooks = mkStringListConfig "Init hooks";
                additional_flags = mkStringListConfig "Additional flags";
                volume = mkStringListConfig "Volumes";
              };
          };
        });
      default = { };
    };
  };
}
