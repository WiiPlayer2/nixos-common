{ lib, config, inputs, withSystem, ... }:
with lib;
let
  cfg = config.nixDir3;
  nixDirLib = cfg.lib;

  first = ls: elemAt ls 0;
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
        loaderPathResult =
          loadCfg:
          path:
          let
            byAttrsNameFn = cursor: (attrNames (filterAttrs (_: v: v == "directory") (builtins.readDir (cfg.src + "/${first cursor}"))));

            nestedNamesFn =
              let
                byAttributeNames =
                  if loadCfg.loadByAttribute
                  then [ byAttrsNameFn ]
                  else [ ];
                systemsNames =
                  if loadCfg._isPerSystem
                  then [ config.systems ]
                  else [ ];
              in
              [ [ path ] ] ++ systemsNames ++ byAttributeNames;

            srcFn =
              if loadCfg.loadByAttribute
              then (cursor: cfg.src + "/${first cursor}/${last cursor}")
              else (cursor: cfg.src + "/${first cursor}");

            baseInputs = loadCfg.extraInputs // cfg.extraInputs // {
              inherit lib inputs;
            };

            haumeaArgsFn =
              if loadCfg._isPerSystem
              then
                (
                  cursor:
                  extraInputs:
                  let
                    src = srcFn cursor;
                    system = elemAt cursor 1;
                    pkgs = inputs.nixpkgs.legacyPackages.${system};
                    scopedArgs = withSystem system (
                      { inputs', config, ... }:
                      {
                        inherit inputs' pkgs;
                        flakeConfig' = config;
                      }
                    );
                    loader = loadCfg.loader pkgs;
                    transformer = loadCfg.transformer pkgs src;
                    _inputs = extraInputs // baseInputs // scopedArgs;
                  in
                  {
                    inherit src loader transformer;
                    inputs = _inputs;
                  }
                )
              else
                (
                  cursor:
                  extraInputs:
                  let
                    src = srcFn cursor;
                    inherit (loadCfg) loader;
                    transformer = loadCfg.transformer src;
                    _inputs = extraInputs // baseInputs;
                  in
                  {
                    inherit src loader transformer;
                    inputs = _inputs;
                  }
                );

            loadResult =
              nixDirLib.helper.recursiveGenAttrs
                nestedNamesFn
                (
                  cursor:
                  let
                    load =
                      extraInputs:
                      inputs.haumea.lib.load (haumeaArgsFn cursor extraInputs);
                    result = loadCfg.loadTransformer load;
                  in
                  result
                );
          in
          {
            ${loadCfg.target} = loadResult.${path};
          };

        loaderResult =
          loadCfg:
          mergeAttrsList
            (
              map
                (loaderPathResult loadCfg)
                loadCfg.paths
            );

        result =
          mergeAttrsList
            (
              map
                loaderResult
                (
                  (attrValues (removeAttrs cfg.loaders [ "perSystem" ]))
                  ++ (attrValues cfg.loaders.perSystem)
                )
            );
      in
      # {
        #   tmp = result;
        # };
      result;
  };
}
