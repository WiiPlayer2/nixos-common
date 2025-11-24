{ lib }:
with lib;
{ extraInputs ? [ ]
}:
{
  loadByAttribute = true;

  transformer = _: [
    transformers.liftDefault
    (transformers.hoistLists "imports" "imports")
    (transformers.hoistAttrs "options" "options")
    (transformers.hoistAttrs "config" "config")
  ];

  loadTransformer =
    load:
    src:
    { pkgs, config, ... } @ moduleArgs:
    let
      extraModuleArgs = intersectAttrs
        (
          genAttrs
            extraInputs
            (_: null)
        )
        moduleArgs;
      extraLoadInputs = { inherit pkgs config; } // extraModuleArgs;
      baseModule = load extraLoadInputs;
      restModule = removeAttrs baseModule [ "imports" "options" "config" ];
      coreModule = intersectAttrs
        {
          imports = [ ];
          options = { };
          config = { };
        }
        baseModule;
      module = coreModule // {
        config = mkMerge [
          coreModule.config or { }
          restModule
        ];
      };
    in
    setDefaultModuleLocation src module;
}
