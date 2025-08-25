{ lib, ... }:
with lib;
let
  mkDefaultEnableOption =
    description:
    mkOption {
      inherit description;
      type = types.bool;
      default = true;
    };
in
{
  options.my.startup = mkOption {
    description = "The commands to execute at startup of desktop environment";
    type =
      with types;
      attrsOf (submodule {
        options = {
          enable = mkDefaultEnableOption "Whether this startup item is enabled.";
          command = mkOption {
            description = "The command to execute on startup";
            type = types.str;
          };
        };
      });
  };
}
