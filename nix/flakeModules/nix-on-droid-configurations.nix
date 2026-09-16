_:
{ lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in

{
  options = {
    flake.nixOnDroidConfigurations = mkOption {
      type = types.lazyAttrsOf types.raw;
      default = { };
    };
  };
}
