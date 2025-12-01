{ super, lib, inputs, config, withSystem }:
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
        default = _: inputs.haumea.lib.loaders.default;
      };

      transformer = mkOption {
        type = with types; raw; # TODO: haumea transformer or transformers list
        default = _: _: [ ];
      };
    };

    config = {
      _isPerSystem = true;
      haumeaArgs =
        pkgs:
        let
          _inputs =
            config.extraInputs //
            super.globalInputs //
            (
              withSystem
                pkgs.stdenv.hostPlatform.system
                (
                  { inputs', config, ... }:
                  {
                    inherit
                      pkgs
                      inputs'
                      ;
                    config' = config;
                  }
                )
            );
          forPath =
            path:
            {
              src = cfg.src + "/${path}";
              inputs = _inputs;
              loader = config.loader pkgs;
              transformer = super.transformersForPath path (config.transformer pkgs);
            };
          args =
            map
              forPath
              config.paths;
        in
        args;
    };
  }
)
