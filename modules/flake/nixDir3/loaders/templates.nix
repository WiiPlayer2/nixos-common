{ lib, inputs, ... }:
with lib;
with inputs.haumea.lib;
let
  textLoader = _: readFile;
in
{
  nixDir3.loaders.templates = {
    loadByAttribute = true;

    loader = [
      (matchers.extension "md" textLoader)
      (matchers.always loaders.default)
    ];

    transformer =
      src:
      cursor:
      data:
      if length cursor == 1 && elemAt cursor 0 == "path"
      then src + "/${elemAt cursor 0}"
      else data;
  };
}
