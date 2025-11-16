{ lib, config, ... }:
with lib;
with config.nixDir3.lib;
{
  nixDir3.loaders =
    genAttrs
      [
        "nixosModules"
        "homeModules"
      ]
      (_: loaders.modules { });
}
