{ lib, pkgs }:
with lib;
{
  imageConfig = mkOption {
    type = (pkgs.formats.json { }).type;
  };

  script = mkOption {
    type = types.lines;
  };

  entrypointScript = mkOption {
    type = types.package;
    readOnly = true;
    internal = true;
  };

  entrypointActivateScript = mkOption {
    type = types.package;
    readOnly = true;
    internal = true;
  };
}
