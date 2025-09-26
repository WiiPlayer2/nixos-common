{ config, hostConfig, inputs, ... }:
let
  identityBasePath = inputs.self + "/secrets/hosts/${hostConfig.name}/identity-${hostConfig.mainUser}";
in
{
  age.secrets."user-identity-${hostConfig.mainUser}" = {
    rekeyFile = identityBasePath + ".age";
    generator.script = "age-identity";
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
