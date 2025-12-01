{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.components.graphical.social.teams;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      home.packages = with pkgs; [
        teams-for-linux
      ];

      my.startup.teams.command = "teams-for-linux --minimized --optInTeamsV2";
    };
}
