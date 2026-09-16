{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with config.nixDir.lib;
{
  nixDir.loaders.nixOnDroidConfigurations = presets.modules {
    apply =
      module:
      inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import inputs.nixpkgs { system = "aarch64-linux"; };
        modules = [ module ];
      };

    config.aliases = [ "nixOnDroid" ];
  };
}
