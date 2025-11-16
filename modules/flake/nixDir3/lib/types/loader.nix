{ super, lib, inputs, config }:
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
        default = inputs.haumea.lib.loaders.default;
      };

      transformer = mkOption {
        type = with types; raw; # TODO: haumea transformer or transformers list
        default = [ ];
      };
    };

    config = {
      haumeaArgs =
        let
          _inputs =
            config.extraInputs //
            globalInputs;
          forPath =
            path:
            {
              src = cfg.src + "/${path}";
              inputs = _inputs;
              inherit (config) loader;
              transformer = transformersForPath path config.transformer;
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
