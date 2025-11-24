{ lib, inputs, ... }:
with lib;
{
  nixDir3.loaders.nixosConfigurations = {
    loadByAttribute = true;

    loadTransformer =
      load:
      src:
      inputs.nixpkgs.lib.nixosSystem (load { });
  };
}
