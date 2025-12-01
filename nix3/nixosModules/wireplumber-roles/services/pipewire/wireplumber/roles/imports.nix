{ lib }:
with lib;
[
  (
    { config, ... }:
    let
      cfg = config.services.pipewire.wireplumber.roles;
      loopbackSinkRoleName = role: "loopback.sink.role.${role}";
      mkLoopbackSink =
        {
          name,
          description,
          intendedRoles,
        }:
        {
          type = "pw-module";
          name = "libpipewire-module-loopback";
          arguments = {
            "node.name" = "loopback.sink.role.${name}";
            "node.description" = description;
            "audio.position" = [
              "FL"
              "FR"
            ];
            "capture.props" = {
              "device.intended-roles" = intendedRoles;
              # "policy.roles.priority" = priority;
              # "policy.roles.action.same-priority" = "mix";
              # "policy.roles.action.lower-priority" = lowerPriorityAction;
              # Explicitly mark all these sinks as valid roles policy
              # targets, meaning that any links between streams and these sinks
              # will be managed by the roles policy
              "policy.roles.target" = true;

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
    {
      config = mkIf cfg.enable {
        assertions = [
          {
            assertion = config.services.pipewire.wireplumber.roles.roles ? "${cfg.defaultRole}";
            message = "WirePlumber role ${cfg.defaultRole} is not configured";
          }
        ];

        services.pipewire.wireplumber.extraConfig = {
          "roles" = {
            "wireplumber.profiles".main = genAttrs (map loopbackSinkRoleName (attrNames cfg.roles)) (
              _: "required"
            );

            "wireplumber.components" = map mkLoopbackSink (attrValues cfg.roles);
          };
        };
      };
    }
  )
]
