{ super, lib, inputs, config, withSystem }:
with lib;
let
  cfg = config.nixDir3;

  globalInputs = cfg.extraInputs // {
    inherit lib inputs config;
  };

  transformerForPath =
    path:
    transformer:
    cursor:
    transformer ([ path ] ++ cursor);

  transformersForPath =
    path:
    transformerConfig:
    if isList transformerConfig
    then map (transformerForPath path) transformerConfig
    else transformerForPath path transformerConfig;
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
        default = _: [ ];
      };
    };

    config = {
      haumeaArgs =
        pkgs:
        let
          _inputs =
            config.extraInputs //
            globalInputs //
            (
              withSystem
                pkgs.system
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
              transformer = transformersForPath path (config.transformer pkgs);
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
