{ lib, config, inputs, ... }:
with lib;
with inputs.haumea.lib;
let
  cfg = config.nixDir3;

  textLoader = _: readFile;
in
{
  nixDir3.loaders.templates = {
    loader = [
      (matchers.extension "md" textLoader)
      (matchers.always loaders.default)
    ];

    transformer =
      cursor:
      data:
      if length cursor == 3 && elemAt cursor 2 == "path"
      then cfg.src + ("/${join "/" cursor}")
      else data;
  };
}
