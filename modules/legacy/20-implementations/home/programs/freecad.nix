{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.freecad;
in
{
  config = mkIf cfg.enable {
    home.packages =
      warnIf (pkgs.freecad.version == "1.1.3") "freecad dep currently fails to build and is disabled"
        (
          throwIfNot (
            pkgs.freecad.version == "1.1.3"
          ) "freecad now ships with version ${pkgs.freecad.version}" [ ]
        );
  };
}
