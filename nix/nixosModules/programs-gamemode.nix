_:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.gamemode;
  startScript = pkgs.writeShellScriptBin "gamemode-start" cfg.startCommands;
  endScript = pkgs.writeShellScriptBin "gamemode-stop" cfg.endCommands;
in
{
  options.programs.gamemode = {
    startCommands = mkOption {
      type = types.lines;
      default = "";
    };
    endCommands = mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    programs.gamemode.settings.custom = {
      start = getExe startScript;
      end = getExe endScript;
    };
  };
}
