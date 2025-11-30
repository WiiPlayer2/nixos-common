{ lib, config, pkgs }:
with lib;
let
  cfg = config.containerImage;

  script = pkgs.writeShellScript "container-script" cfg.script;
  entrypointScript = pkgs.writeShellScript "container-command-script" ''
    ${config.system.build.toplevel}/activate
    exec ${script}
  '';
in
{
  imageConfig = {
    Cmd = [ entrypointScript ];
  };
}
