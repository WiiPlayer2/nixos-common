{ lib, inputs, ... }:
with lib;
with inputs.haumea.lib;
{
  nixDir3.loaders.nixosModules = {
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
      setDefaultModuleLocation src (load { });
  };
}
