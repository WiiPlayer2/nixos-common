{ lib, ... }:
with lib;
{
  nixDir3.loaders.perSystem.devShells = {
    transformer =
      pkgs:
      cursor:
      data:
      let
        defaultArgs =
          { name ? (elemAt cursor 0)
          , ...
          } @ args: {
            inherit name;
          } // args;
      in
      if length cursor != 1
      then data
      else pkgs.mkShell (defaultArgs data);
  };
}
