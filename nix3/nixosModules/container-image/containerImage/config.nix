{ lib, config, pkgs }:
with lib;
let
  cfg = config.containerImage;
in
{
  imageConfig = {
    Cmd = [ cfg.entrypointActivateScript ];
  };

  entrypointScript = pkgs.writeShellScript "entrypoint" cfg.script;

  entrypointActivateScript = pkgs.writeShellScript "entrypoint-activate" ''
    ${config.system.build.toplevel}/activate

    exec ${cfg.entrypointScript}
  '';
}
