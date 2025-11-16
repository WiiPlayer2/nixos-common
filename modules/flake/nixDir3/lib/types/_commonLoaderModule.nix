{ lib }:
with lib;
{ config, ... }:
{
  options = {
    paths = mkOption {
      type = with types; listOf str;
      internal = true;
      readOnly = true;
    };

    aliases = mkOption {
      type = with types; listOf str;
      default = [ ];
    };

    extraInputs = mkOption {
      type = types.lazyAttrsOf types.anything;
      default = { };
    };

    target = mkOption {
      type = with types; str;
      default = config._module.args.name;
    };

    loadTransformer = mkOption {
      type = with types; functionTo raw;
      default = load: load { };
    };

    loadByAttribute = mkOption {
      type = types.bool;
      default = false;
    };

    _isPerSystem = mkOption {
      type = types.bool;
      internal = true;
      readOnly = true;
    };
  };

  config = {
    paths = [ config._module.args.name ] ++ config.aliases;
  };
}
