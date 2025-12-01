{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.code-server;
in
{
  options.services.code-server = {
    enable = lib.mkEnableOption "Code Server";
  };

  config =
    with lib;
    mkIf cfg.enable {
      environment.packages = with pkgs; [
        code-server
      ];

      programs.supervisord.config.programs.code-server = {
        command = "${pkgs.code-server}/bin/code-server";
        startsecs = 20;
      };
    };
}
