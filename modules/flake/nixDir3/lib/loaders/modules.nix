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
      module = intersectAttrs {
        imports = [ ];
        options = { };
        config = { };
      } baseModule;
    in
    setDefaultModuleLocation src module;
}
