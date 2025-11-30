{ lib, pkgs }:
with lib;
{
  imageConfig = mkOption {
    type = (pkgs.formats.json { }).type;
  };

  script = mkOption {
    type = types.lines;
  };
}
