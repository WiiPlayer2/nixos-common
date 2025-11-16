{ lib, config, inputs, withSystem, ... }:
with lib;
let
  cfg = config.nixDir3;
  nixDirLib = cfg.lib;

  recursiveMergeAttrsList =
    foldl
      recursiveUpdate
      { };
in
{
  imports = [
    ./loaders
  ];

  options.nixDir3 = {
    lib = mkOption {
      type = types.raw;
      readOnly = true;
      default =
        inputs.haumea.lib.load {
          src = ./lib;
          inputs = {
            inherit config inputs withSystem;
            lib = extend (_: _: inputs.haumea.lib);
          };
        };
    };

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
            freeformType = types.lazyAttrsOf nixDirLib.types.loader;
            options = {
              perSystem = mkOption {
                type = types.lazyAttrsOf nixDirLib.types.perSystemLoader;
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
