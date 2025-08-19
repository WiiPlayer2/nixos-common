{ lib, config, ... }:
with lib;
let
  cfg = config.services.pipewire.wireplumber.roleBasedLinkingPolicy;
in
{
  options.services.pipewire.wireplumber.roleBasedLinkingPolicy = {
    enable = mkEnableOption "Whether the role-based linking policy for wireplumber should be enabled.";
  };

  config = mkIf cfg.enable {
    services.pipewire.wireplumber.extraConfig."role-based-linking-policy" = {
      "wireplumber.profiles" = {
        main = {
          "policy.linking.role-based.loopbacks" = "required";
          "loopback.sink.role.multimedia" = "required";
          "loopback.sink.role.notification" = "required";
          "loopback.sink.role.assistant" = "required";
        };
      };
      "wireplumber.settings" = {
        "node.stream.default-media-role" = "Multimedia";
        "linking.role-based.duck-level" = 0.3;
      };
      "wireplumber.components" =
        let
          mkLoopbackSink =
            { name
            , description
            , intendedRoles
            , priority
            , lowerPriorityAction
            ,
            }:
            {
              type = "pw-module";
              name = "libpipewire-module-loopback";
              arguments = {
                "node.name" = "loopback.sink.role.${name}";
                "node.description" = description;
                "audio.position" = [ "FL" "FR" ];
                "capture.props" = {
                  "device.intended-roles" = intendedRoles;
                  "policy.role-based.priority" = priority;
                  "policy.role-based.action.same-priority" = "mix";
                  "policy.role-based.action.lower-priority" = lowerPriorityAction;
                  # Explicitly mark all these sinks as valid role-based policy
                  # targets, meaning that any links between streams and these sinks
                  # will be managed by the role-based policy
                  "policy.role-based.target" = true;

                  "media.class" = "Audio/Sink";
                };
                "playback.props" = {
                  # This must be set to ensure that the real audio sink is suspended
                  # when there is no active client stream linked
                  "node.passive" = true;
                  # Set this to an unused role to make sure that loopbacks don't
                  # accidentally chain-link on to one another, especially when
                  # node.stream.default-media-role is configured in the settings
                  "media.role" = "Loopback";
                };
              };
              provides = "loopback.sink.role.${name}";
            };
        in
        [
          (mkLoopbackSink {
            name = "multimedia";
            description = "Multimedia";
            intendedRoles = [ "Music" "Movie" "Game" "Multimedia" ];
            priority = 10;
            lowerPriorityAction = "mix";
          })
          (mkLoopbackSink {
            name = "notification";
            description = "Notification";
            intendedRoles = [ "Notification" ];
            priority = 30;
            lowerPriorityAction = "duck";
          })
          (mkLoopbackSink {
            name = "assistant";
            description = "Voice Assistant";
            intendedRoles = [ "Assistant" ];
            priority = 40;
            lowerPriorityAction = "duck";
          })
          {
            type = "virtual";
            provides = "policy.linking.role-based.loopbacks";
            requires = [
              # "loopback.sink.role.multimedia"
              # "loopback.sink.role.notification"
              # "loopback.sink.role.assistant"
            ];
          }
        ];
    };
  };
}
