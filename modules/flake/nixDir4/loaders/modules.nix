{ lib, config, ... }:
with lib;
with config.nixDir4.lib;
{
  nixDir4.loaders = mapAttrs (_: loaders.modules) {
    nixosModules = { };
    homeModules = { };
    nixOnDroidModules = { };
  };
}
