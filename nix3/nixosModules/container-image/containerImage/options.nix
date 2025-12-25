{
  lib,
  pkgs,
  config,
}:
with lib;
{
  name = mkOption {
    type = types.str;
    default = "nixos-oci-container-${config.system.name}";
  };

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

  systemdService = mkOption {
    type = with types; nullOr str;
    default = "";
  };
}
