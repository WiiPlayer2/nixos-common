{
  super,
  lib,
}:
with lib;
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
