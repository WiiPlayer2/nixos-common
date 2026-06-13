{ lib, pkgs, ... }:
with lib;
{
  services.ludusavi = {
    enable = true;
    backupNotification = true;

    settings = {
      release.check = false;

      manifest = {
        enable = true;
        secondary = [
          # TODO: maybe migrate to customGames setting
          {
            enable = true;
            path = ./_ludusavi-extra-manifest.yaml;
          }
        ];
      };

      roots = [
        {
          store = "steam";
          path = "~/.local/share/Steam";
        }
        {
          store = "lutris";
          path = "~/.config/lutris";
          database = "~/.local/share/lutris/pga.db";
        }
        {
          store = "heroic";
          path = "~/.config/heroic";
        }
      ];

      backup = {
        path = "~/ludusavi-backup";
        ignoredGames = [
          "Honey Select"
          "HoneySelect2Libido DX"
        ];
        retention = {
          full = 3;
          differential = 9;
        };
      };

      restore.path = "~/ludusavi-backup";

      cloud = {
        remote.Custom.id = "ludusavi";
        path = "backups";
        synchronize = true;
      };

      apps.rclone = {
        path = getExe pkgs.rclone;
        arguments = "--fast-list --ignore-checksum";
      };

      theme = "dark";
    };
  };

  systemd.user.timers.ludusavi = {
    Timer.Persistent = true;
  };
}
