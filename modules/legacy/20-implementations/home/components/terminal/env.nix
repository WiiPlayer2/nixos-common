{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.terminal;
  cfgGraphical = config.my.components.graphical;
in
{
  # TODO add dotnet tools path (/home/admin/.dotnet/tools) to PATH
  config =
    with lib;
    mkIf cfg.enable {
      home.sessionVariables = {
        EDITOR = if cfgGraphical.enable then "code -w" else "nano";
      };
    };
}
