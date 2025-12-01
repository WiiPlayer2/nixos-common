{ lib }:
with lib;
{
  enable = mkEnableOption "";

  defaultRole = mkOption {
    type = types.str;
    default = "Multimedia";
  };

  roles = mkOption {
    type = types.attrsOf (
      types.submodule (
        { config, ... }:
        {
          options = {
            name = mkOption {
              type = types.str;
              default = config._module.args.name;
            };

            description = mkOption {
              type = types.str;
              default = config.name;
            };

            intendedRoles = mkOption {
              type =
                with types;
                listOf (enum [
                  "A11y"
                  "Alarm"
                  "Alert"
                  "Emergency"
                  "Game"
                  "Movie"
                  "Multimedia"
                  "Music"
                  "Navigation"
                  "GPS"
                  "Notification"
                  "event"
                  "Ringtone"
                  "Assistant"
                  "Communication"
                  "Phone"
                ]);
              default = [ ];
              description = "see https://gitlab.freedesktop.org/xdg/xdg-specs/-/issues/202";
            };
          };
        }
      )
    );
    default = {
      Accessibility.intendedRoles = [ "A11y" ];
      Alarm.intendedRoles = [ "Alarm" ];
      Alerts.intendedRoles = [
        "Alert"
        "Emergency"
      ];
      Game.intendedRoles = [ "Game" ];
      Movie.intendedRoles = [ "Movie" ];
      Multimedia.intendedRoles = [ "Multimedia" ];
      Music.intendedRoles = [ "Music" ];
      Navigation.intendedRoles = [
        "Navigation"
        "GPS"
      ];
      Notifications.intendedRoles = [
        "Notification"
        "event"
      ];
      Ringtones.intendedRoles = [ "Ringtone" ];
      "Voice Assistant".intendedRoles = [ "Assistant" ];
      Voice.intendedRoles = [
        "Communication"
        "Phone"
      ];
    };
  };
}
