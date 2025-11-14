{ lib, config, inputs, withSystem, ... }:
with lib;
let
  cfg = config.nixDir3;

  globalInputs = cfg.extraInputs // {
    inherit inputs config;
  };

  loaderType =
    types.submodule (
      { config, ... }:
      {
        options = {
          paths = mkOption {
            type = with types; listOf str;
            internal = true;
            readOnly = true;
          };

          haumeaArgs = mkOption {
            type = types.raw;
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
          paths = [ config._module.args.name ] ++ config.aliases;
          # haumeaArgs =
          #   let
          #     inputsList =
          #       map
          #         (x: cfg.extraInputs // config.extraInputs // globalInputs // x)
          #         extraInputsList;
          #     argsForInputs =
          #       inputs:
          #       map
          #         (path: {
          #           src = cfg.src + "/${path}";
          #           inherit inputs;
          #           inherit (config) loader transformer;
          #         })
          #         config.paths;
          #   in
          #   concatMap
          #     argsForInputs
          #     inputsList;
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
                  inherit (config) loader transformer;
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
        options = {
          paths = mkOption {
            type = with types; listOf str;
            internal = true;
            readOnly = true;
          };

          haumeaArgs = mkOption {
            type = types.raw;
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
          paths = [ config._module.args.name ] ++ config.aliases;
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
                  transformer = config.transformer pkgs;
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
            # freeformType = types.lazyAttrsOf (loaderType ({ config, ... }: {
            #   config = {
            #     haumeaArgs =
            #       let
            #         _inputs = cfg.extraInputs // config.extraInputs // globalInputs;
            #         inputsList =
            #           map
            #             (x: cfg.extraInputs // config.extraInputs // globalInputs // x)
            #             extraInputsList;
            #         argsForInputs =
            #           inputs:
            #           map
            #             (path: {
            #               src = cfg.src + "/${path}";
            #               inherit inputs;
            #               inherit (config) loader transformer;
            #             })
            #             config.paths;
            #       in
            #       argsForInputs
            #         _inputs;
            #   };
            # }));
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
        # load =
        #   listArgs:
        #   loadCfg:
        #   mergeAttrsList
        #     (
        #       map
        #         inputs.haumea.lib.load
        #         (listArgs loadCfg.haumeaArgs)
        #     );
        # perSystemResult =
        #   mapAttrs
        #     (_: loadCfg:
        #       genAttrs
        #       (attrNames loadCfg.haumeaArgs)
        #       (system: load (x: x.${system}) loadCfg)
        #     )
        #     cfg.loaders.perSystem;
        # globalResult =
        #   mapAttrs
        #     (_: load (x: x))
        #     (removeAttrs cfg.loaders [ "perSystem" ]);
        systemResult =
          loadCfg:
          system:
          let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            load =
              loadCfg:
              mergeAttrsList
                (
                  map
                    inputs.haumea.lib.load
                    (loadCfg.haumeaArgs pkgs)
                );
            result =
              load loadCfg;
          in
          result;
        perSystemLoaderResult =
          loadCfg:
          genAttrs
            config.systems
            (systemResult loadCfg);
        perSystemResult =
          mapAttrs
            (_: perSystemLoaderResult)
            cfg.loaders.perSystem;
        loaderResult =
          loadCfg:
          let
            load =
              mergeAttrsList
                (
                  map
                    inputs.haumea.lib.load
                    loadCfg.haumeaArgs
                );
          in
          load;
        globalResult =
          mapAttrs
            (_: loaderResult)
            (removeAttrs cfg.loaders [ "perSystem" ]);
        result =
          recursiveUpdate globalResult perSystemResult;
      in
      result;
  };
}
