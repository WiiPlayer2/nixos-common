{ lib, config, ... }:
with lib;
with config.nixDir3.lib;
{
  nixDir3.loaders = mapAttrs (_: loaders.modules) {
    nixosModules = {
      extraInputs = [
        "modulesPath"
      ];
    };
    homeModules = { };
    nixOnDroidModules = { };
  };
}
