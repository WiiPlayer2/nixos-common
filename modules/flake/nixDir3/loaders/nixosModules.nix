{ lib, config, inputs, ... }:
with lib;
with inputs.haumea.lib;
let
  cfg = config.nixDir3;

  transformerForLevel =
    levelPred:
    transformer:
    cursor:
    data:
    if levelPred (length cursor)
    then transformer cursor data
    else data;

  transformerFromLevel =
    level:
    transformerForLevel (l: l >= level);

  combineTransformers =
    transformers:
    cursor:
    flip pipe (map (t: t cursor) (flatten transformers));
in
{
  nixDir3.loaders.nixosModules = {
    transformer = [
      (
        transformerFromLevel 2 (combineTransformers [
          transformers.liftDefault
          (transformers.hoistLists "imports" "imports")
          (transformers.hoistAttrs "options" "options")
          (transformers.hoistAttrs "config" "config")
          (_: intersectAttrs {
            imports = [ ];
            options = { };
            config = { };
          })
        ])
      )
    ];
  };
}
