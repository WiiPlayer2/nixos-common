{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with config.nixDir.lib;
{
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
  ];

  nixDir.loaders = mapAttrs (_: presets.modules) {
    nixosModules = { };
    homeModules = { };
    nixOnDroidModules = { };
    flakeModules = { };
  };
}
