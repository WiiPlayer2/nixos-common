{
  lib,
  config,
  hostConfig,
  flakeRoot,
  ...
}:
with lib;
let
  identityBasePath = flakeRoot + "/secrets/hosts/${hostConfig.name}/identity-${hostConfig.mainUser}";
  hmAge = config.home-manager.users.${hostConfig.mainUser}.age;
  hasHomeSecrets = hmAge.secrets != { };
in
{
  config = mkMerge [
    (mkIf hasHomeSecrets {
      age.secrets."user-identity-${hostConfig.mainUser}" = {
        rekeyFile = identityBasePath + ".age";
        generator.script = "age-identity";
        owner = hostConfig.mainUser;
      };
    })

    {
      home-manager.users.${hostConfig.mainUser}.age = {
        rekey = mkIf hasHomeSecrets {
          hostPubkey = identityBasePath + ".pub";
        };
        identityPaths =
          optional hasHomeSecrets
            config.age.secrets."user-identity-${hostConfig.mainUser}".path;
      };
    }
  ];
}
