{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.my.components.graphical.social.pidgin;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      my.meta.brokenPackages = with pkgs; [
        tdlib-purple
      ];

      programs.pidgin = {
        enable = true;
        plugins = with pkgs.pidginPackages; [
          # tdlib-purple
          purple-slack
          # purple-matrix # insecure
          purple-signald
          purple-discord
          pidgin-opensteamworks
        ];
      };

      my.components.graphical.startup.pidgin.command = "pidgin";
    };
}
