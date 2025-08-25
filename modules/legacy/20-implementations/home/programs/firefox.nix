{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.firefox;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unstable.firefoxpwa
    ];

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = [
        pkgs.unstable.firefoxpwa
      ];
      profiles.default-release = {
        settings = {
          "network.websocket.allowInsecureFromHTTPS" = true;
        };
      };
    };
  };
}
