{ lib, config, ... }:
with lib;
with config.nixDir.lib;
{
  nixDir.loaders = mapAttrs (_: loaders.modules) {
    nixosModules = { };
    homeModules = { };
    nixOnDroidModules = { };
  };
}
