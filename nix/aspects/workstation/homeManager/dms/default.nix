{ lib, config, ... }:
with lib;
let
  restartCommand = "${getExe config.programs.dank-material-shell.package} restart";
in
{
  programs = {
    dank-material-shell = {
      enable = true;
      systemd.enable = true;
    };
  };

  xdg.configFile = {
    "DankMaterialShell/settings.json".onChange = restartCommand;
    "DankMaterialShell/plugin_settings.json".onChange = restartCommand;
  };

  systemd.user.services.dms.Service.Environment = [
    # see https://github.com/AvengeMedia/DankMaterialShell/blob/335c5b4ac55382c2077ab2a18129c03dafb9558b/quickshell/Common/settings/Processes.qml#L78
    # TODO: should depend on fprint setting and/or service OR fix implementation to recognize correctly
    "DMS_FORCE_FPRINT_AVAILABLE=1"
    # "DMS_FORCE_U2F_AVAILABLE=1"
  ];
}
