{ lib, inputs, ... }:
with lib;

{
  name,
  systems ? [ "x86_64-linux" ],
  modules ? [ ],
}:

let
  mkImage =
    system:
    let
      nixosConfig = inputs.nixpkgs.lib.nixosSystem {
        modules = modules ++ [
          inputs.self.nixosModules.container-image
          {
            nixpkgs.hostPlatform = system;
            containerImage.name = name;
          }
        ];
      };
    in
    nixosConfig.config.system.build.image;

  images = genAttrs systems mkImage;
in
images
