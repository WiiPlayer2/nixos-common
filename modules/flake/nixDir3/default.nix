{ lib, config, inputs, withSystem, ... }:
with lib;
let
  cfg = config.nixDir3;

  recursiveMergeAttrsList =
    foldl
      recursiveUpdate
      { };

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

  commonLoaderTypeModule =
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
      };

      config = {
        paths = [ config._module.args.name ] ++ config.aliases;
      };
    };

  loaderType =
    types.submodule (
      { config, ... }:
      {
        imports = [
          commonLoaderTypeModule
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
    );

  perSystemLoaderType =
    types.submodule (
      { config, ... }:
      {
        imports = [
          commonLoaderTypeModule
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
    );
in
{
  imports = [
    ./loaders
  ];

  options.nixDir3 = {
    root = mkOption {
      type = types.path;
    };

    src = mkOption {
      type = types.path;
      default = cfg.root + /nix3;
    };

    extraInputs = mkOption {
      type = types.lazyAttrsOf types.anything;
      default = { };
    };

    loaders = mkOption {
      type = types.submoduleWith {
        modules = [
          {
            freeformType = types.lazyAttrsOf loaderType;
            options = {
              perSystem = mkOption {
                type = types.lazyAttrsOf perSystemLoaderType;
                default = { };
              };
            };
          }
        ];
      };
    };
  };

  config = {
    flake =
      let
        evalLoader =
          transformArgs:
          transformResult:
          loadCfg:
          let
            load =
              args:
              extraInputs:
              inputs.haumea.lib.load (args // {
                inputs = extraInputs // args.inputs;
              });
            result =
              mergeAttrsList
                (
                  map
                    (args: loadCfg.loadTransformer (load args))
                    (transformArgs loadCfg.haumeaArgs)
                );
          in
          { ${loadCfg.target} = transformResult result; };
        perSystemResult =
          recursiveMergeAttrsList
            (
              concatMap
                (
                  system:
                  map
                    (
                      evalLoader
                        (args: args inputs.nixpkgs.legacyPackages.${system})
                        (result: { ${system} = result; })
                    )
                    (attrValues cfg.loaders.perSystem)
                )
                config.systems
            );
        globalResult =
          mergeAttrsList
            (
              map
                (evalLoader id id)
                (attrValues (removeAttrs cfg.loaders [ "perSystem" ]))
            );
        result =
          recursiveUpdate globalResult perSystemResult;
      in
      result;
  };
}
