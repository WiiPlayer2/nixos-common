{ lib, config, inputs, withSystem, ... }:
with lib;
let
  cfg = config.nixDir3;

  globalInputs = {
    inherit inputs;
  };

  loaderType =
    extraInputsList:
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
          haumeaArgs =
            let
              inputsList =
                map
                  (x: cfg.extraInputs // config.extraInputs // globalInputs // x)
                  extraInputsList;
              argsForInputs =
                inputs:
                map
                  (path: {
                    src = cfg.src + "/${path}";
                    inherit inputs;
                    inherit (config) loader transformer;
                  })
                  config.paths;
            in
            concatMap
              argsForInputs
              inputsList;
        };
      }
    );
in
{
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
            freeformType = types.lazyAttrsOf (loaderType [{ }]);
            options = {
              perSystem = mkOption {
                type = types.lazyAttrsOf (loaderType (
                  map
                    (system: withSystem system ({ pkgs, inputs', ... }: { inherit pkgs inputs'; }))
                    config.systems
                ));
                default = { };
              };
            };
          }
        ];
      };
    };

    loadables = {
      tmp = mkOption {
        type = types.raw;
      };
      devShells = mkOption {
        type = types.lazyAttrsOf (types.submodule (
          { config, ... }:
          {
            options = {
              name = mkOption {
                type = types.str;
                default = config._module.args.name;
              };

              packages = mkOption {
                type = with types; functionTo (listOf package);
                default = [ ];
              };
            };
          }
        ));
      };
    };
  };

  config = {
    nixDir3 = {
      loaders.perSystem.devShells = { };
      loadables.tmp =
        let
          load =
            loadCfg:
            mergeAttrsList
              (
                map
                  inputs.haumea.lib.load
                  loadCfg.haumeaArgs
              );
          perSystemResult =
            mapAttrs
              (_: load)
              cfg.loaders.perSystem;
          globalResult =
            mapAttrs
              (_: load)
              (removeAttrs cfg.loaders [ "perSystem" ]);
          result =
            recursiveUpdate globalResult perSystemResult;
        in
        result;
    };

    flake.tmp = config.nixDir3.loadables.tmp;
    flake.devShells =
      let
        mkDevShell =
          pkgs:
          devShellCfg:
          pkgs.mkShell {
            inherit (devShellCfg) name;
            packages = devShellCfg.packages pkgs;
          };

        devShellSet =
          pkgs:
          mapAttrs
            (_: mkDevShell pkgs);

        devShells =
          genAttrs
            config.systems
            (system: devShellSet inputs.nixpkgs.legacyPackages.${system} config.nixDir3.loadables.devShells);
      in
      devShells;
  };
}
