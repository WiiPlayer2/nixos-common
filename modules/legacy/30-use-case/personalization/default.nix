{
  lib,
  flake-inputs,
  pkgs,
  config,
  ...
}:
with lib;
let
  self = flake-inputs.self;
  colorType = self.lib.types.color;
  fromHex = self.lib.color.fromHex;
in
{
  options.my.personalization = {
    colorScheme = mkOption {
      description = "The base16 scheme to use";
      type = with types; either str path;
    };
    wallpaper = mkOption {
      description = "The wallpaper to use";
      type = with types; nullOr path;
      default = null;
    };
  };
}
