{ lib, ... }:
with lib;
{
  options.my.storage = {
    cloud = mkOption {
      description = "Configuration of cloud storage locations";
      type =
        with types;
        attrsOf (submodule {
          options = {
            location = mkOption {
              description = "The location of the cloud storage directory";
              type = types.str;
            };
          };
        });
      default = { };
    };
  };
}
