{ lib, ... }:
with lib;
{
  options.my.identity = {
    ssh = mkOption {
      description = "SSH Public Keys";
      type =
        with types;
        attrsOf (submodule {
          options = {
            enable = mkOption {
              description = "Enable this public key";
              type = bool;
              default = true;
            };
            key = mkOption {
              description = "The SSH public key";
              type = str;
            };
          };
        });
      default = { };
    };
  };
}
