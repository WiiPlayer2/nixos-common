{
  super,
  lib,
  inputs,
  config,
}:
with lib;
let
  cfg = config.nixDir3;
in
types.submodule (
  { config, ... }:
  {
    imports = [
      super.commonLoaderModule
    ];

    options = {
      loader = mkOption {
        type = with types; raw; # loader function
      };
    };

    config = {
      _isPerSystem = false;
    };
  }
)
