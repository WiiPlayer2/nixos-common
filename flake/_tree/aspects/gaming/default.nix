{ lib, ... }:
with lib;
{
  flake.aspects.gaming = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          (
            let
              launcher = writeShellScriptBin "ludusavi-wrap-lutris-run" ''
                export LD_LIBRARY_PATH="$__ludusavi__LD_LIBRARY_PATH"
                unset __ludusavi__LD_LIBRARY_PATH
                exec "$@"
              '';
            in
            writeShellScriptBin "ludusavi-wrap-lutris" ''
              export __ludusavi__LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
              unset LD_LIBRARY_PATH
              exec ${getExe ludusavi} wrap --infer lutris --gui --force --no-force-cloud-conflict -- ${getExe launcher} "$@"
            ''
          )

          (heroic.override {
            extraPkgs =
              pkgs': with pkgs'; [
                gamemode
              ];
          })
        ];
      };
  };
}
