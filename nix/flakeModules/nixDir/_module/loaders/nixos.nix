{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with config.nixDir.lib;
{
  nixDir.loaders.nixosConfigurations = loaders.modules {
    apply =
      module:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [ module ];
      };

    config.aliases = [ "nixos" ];
  };
}
