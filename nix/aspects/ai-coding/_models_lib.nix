{ lib, ... }:
with lib;
let
  modelsFile = ./_models.nix;
  modelsHfFile = ./_models_hf.json;

  models = import modelsFile;
  modelsHf = builtins.fromJSON (builtins.readFile modelsHfFile);

  enrichModel =
    id:
    let
      model = models.${id};
      modelHf = modelsHf.${id};
    in
    {
      hf = modelHf;

      name =
        let
          repoPart = last (split "/" modelHf.id);
          replaced = replaceStrings [ "-" ] [ " " ] repoPart;
          withoutGguf = removeSuffix " GGUF" replaced;
        in
        withoutGguf;

      repo = modelHf.id;

      quants =
        if model ? quants then
          model.quants
        else if model ? quant then
          [ model.quant ]
        else
          [ null ];
    };

  enrichedModels = mapAttrs (n: v: v // (enrichModel n)) models;
in
{
  models = enrichedModels;

  modelVariants =
    let
      # str -> {} -> []
      modelVariants' =
        id: model:
        let
          # str? -> {}
          mkVariant = quant: {
            name = "${id}${if quant == elemAt model.quants 0 then "" else ":${quant}"}";
            value = {
              inherit quant model;
              name = "${model.name}${if quant == elemAt model.quants 0 then "" else " (${quant})"}";
            };
          };
        in
        map mkVariant model.quants;
    in
    listToAttrs (flatten (mapAttrsToList modelVariants' enrichedModels));
}
