{ config, hostConfig, flakeRoot, ... }:
let
  identityBasePath = flakeRoot + "/secrets/hosts/${hostConfig.name}/identity-${hostConfig.mainUser}";
in
{
  age.secrets."user-identity-${hostConfig.mainUser}" = {
    rekeyFile = identityBasePath + ".age";
    generator.script = "age-identity";
    owner = hostConfig.mainUser;
  };

  home-manager.users.${hostConfig.mainUser}.age = {
    rekey = {
      hostPubkey = identityBasePath + ".pub";
    };
    identityPaths = [
      config.age.secrets."user-identity-${hostConfig.mainUser}".path
    ];
  };
}
