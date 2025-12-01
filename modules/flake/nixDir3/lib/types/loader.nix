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
      haumeaArgs = mkOption {
        type = types.raw;
        internal = true;
        readOnly = true;
      };

      loader = mkOption {
        type = with types; raw; # haumea loader function or matchers list
        default = inputs.haumea.lib.loaders.default;
      };

      transformer = mkOption {
        type = with types; raw; # TODO: haumea transformer or transformers list
        default = _: [ ];
      };
    };

    config = {
      _isPerSystem = false;
      haumeaArgs =
        let
          _inputs = config.extraInputs // super.globalInputs;
          forPath = path: {
            src = cfg.src + "/${path}";
            inputs = _inputs;
            inherit (config) loader;
            transformer = super.transformersForPath path config.transformer;
          };
          args = map forPath config.paths;
        in
        args;
    };
  }
)
