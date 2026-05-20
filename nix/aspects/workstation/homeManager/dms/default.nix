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
}
