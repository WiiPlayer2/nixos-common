{ lib }:
with lib;
mkOption {
  type = types.lazyAttrsOf (types.submodule (
    { ... }:
    {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
      };
    }
  ));
  default = { };
}
