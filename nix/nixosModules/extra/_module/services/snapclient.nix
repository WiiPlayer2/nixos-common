{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.snapclient;
in
{
  options.services.snapclient = {
    enable = mkEnableOption "Whether the snapclient service should be enabled.";
    package = mkOption {
      type = types.package;
      default = pkgs.snapcast;
    };
    host = mkOption {
      type = types.str;
    };
    player = mkOption {
      type = types.str;
    };
    sampleFormat = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    user = mkOption {
      type = with types; nullOr str;
      default = null;
    };
    asUserService = mkEnableOption "Whether the snapclient service should be a user service.";
    extraArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    systemd =
      let
        baseServiceConfig = {
          script =
            let
              args = [
                "-h"
                cfg.host
                "--player"
                cfg.player
              ]
              ++ (optionals (cfg.sampleFormat != null) [
                "--sampleFormat"
                cfg.sampleFormat
              ])
              ++ cfg.extraArgs;
              args' = escapeShellArgs args;
            in
            "${cfg.package}/bin/snapclient ${args'}";
          serviceConfig = {
            Restart = "always";
            RestartSec = "1s";
          };
        };
      in
      {
        services.snapclient = mkIf (!cfg.asUserService) (
          baseServiceConfig
          // {
            after = [
              "network-online.target"
              "sound.target"
            ];
            requires = [
              "network-online.target"
              "sound.target"
            ];
            wantedBy = [
              "multi-user.target"
            ];
            serviceConfig = baseServiceConfig.serviceConfig // {
              User = mkIf (cfg.user != null) cfg.user;
            };
          }
        );
        user.services.snapclient = mkIf cfg.asUserService (
          baseServiceConfig
          // {
            after = [
              "sockets.target"
            ];
            requires = [
              "sockets.target"
            ];
            wantedBy = [
              "default.target"
            ];
          }
        );
      };
  };
}
