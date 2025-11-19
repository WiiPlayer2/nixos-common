{ lib }:
with lib;
{}:
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
    { pkgs, config, ... }:
    let
      baseModule = load { inherit pkgs config; };
      restModule = removeAttrs baseModule ["imports" "options" "config"];
      coreModule = intersectAttrs {
        imports = [ ];
        options = { };
        config = { };
      } baseModule;
      module = coreModule // {
        config = mkMerge [
          coreModule.config or {}
          restModule
        ];
      };
    in
    setDefaultModuleLocation src module;
}
