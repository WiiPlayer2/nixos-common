{ lib, config, ... }:
with lib;
with config.nixDir3.lib;
{
  nixDir3.loaders =
    genAttrs
      [
        "nixosModules"
        "homeModules"
        "nixOnDroidModules"
      ]
      (_: loaders.modules { });
}
