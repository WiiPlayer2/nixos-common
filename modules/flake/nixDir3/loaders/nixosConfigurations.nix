{ lib, config, inputs, ... }:
with lib;
with config.nixDir3.lib;
let
  modulesLoader = loaders.modules { };
in
{
  nixDir3.loaders.nixosConfigurations = modulesLoader // {
    aliases = [
      "nixos"
    ];

    loadTransformer =
      load:
      src:
      let
        module = modulesLoader.loadTransformer load src;
      in
      inputs.nixpkgs.lib.nixosSystem {
        modules = [ module ];
      };
  };
}
