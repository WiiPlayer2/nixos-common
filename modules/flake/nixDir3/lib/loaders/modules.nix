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
    (_: intersectAttrs {
      imports = [ ];
      options = { };
      config = { };
    })
  ];

  loadTransformer =
    load:
    src:
    { pkgs, ... }:
    setDefaultModuleLocation src (load { inherit pkgs; });
}
