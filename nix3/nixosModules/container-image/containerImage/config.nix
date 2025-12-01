{
  lib,
  config,
  pkgs,
}:
with lib;
let
  cfg = config.containerImage;

  systemdService =
    config.systemd.services.${cfg.systemdService} or {
      path = [ ];
      environment = { };
      serviceConfig.ExecStart = "";
    };
  systemdScript =
    pkgs.writeShellApplication {
      name = "run-${cfg.systemdService}";
      runtimeInputs = systemdService.path;
      text = ''
        ${systemdService.serviceConfig.ExecStartPre or ""}
        ${systemdService.serviceConfig.ExecStart}
      '';
    }
    // systemdService.environment;
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

  script = mkIf (cfg.systemdService != null) (getExe systemdScript);
}
