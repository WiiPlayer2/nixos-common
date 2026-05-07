{
  lib,
  pkgs,
  ...
}:
with lib;
{
  systemd = {
    tmpfiles.settings.attic-push-service = {
      "/var/lib/attic-push" = {
        d = {
          user = "root";
          group = "root";
          mode = "0777";
        };
      };
    };

    services.attic-push-service = {
      path = with pkgs; [
        attic-client
      ];
      script = ''
        for _link in /var/lib/attic-push/*; do
          _path=$(realpath "$_link")
          if [[ "$_path" == /nix/store/* ]] && [[ -e "$_path" ]]; then
            attic push default "$_path"
          fi
          rm "$_link"
        done
      '';
    };

    timers.attic-push-service = {
      timerConfig = {
        OnStartupSec = 60;
        OnUnitInactiveSec = 5 * 60;
      };
    };
  };
}
