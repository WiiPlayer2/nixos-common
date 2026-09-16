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
      let
        overlaysModule =
          { options, ... }:
          {
            options.nixpkgs.overlaysEx = options.nixpkgs.overlays;
          };

        pkgs = import inputs.nixpkgs { system = "aarch64-linux"; };
        pkgsEx = import inputs.nixpkgs {
          system = "aarch64-linux";
          overlays = config.config.nixpkgs.overlaysEx;
        };
        config = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
          inherit pkgs;
          modules = [
            overlaysModule
            module
          ];
          extraSpecialArgs.pkgs = pkgsEx;
        };
      in
      config;

    config.aliases = [ "nixOnDroid" ];
  };
}
