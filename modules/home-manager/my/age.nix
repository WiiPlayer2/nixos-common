{ config, hostConfig, inputs, ... }:
{
  age.rekey = {
    masterIdentities = [
      {
        identity = inputs.self + "/secrets/identities/yubikey.pub";
        pubkey = "age1yubikey1qfphf9vkgzv3kt80nuz5dpeuchmxa6tcsaypkmzvl6ngtnd34jmysqm4vaz";
      }
    ];
    extraEncryptionPubkeys = [
      "age1pvdtjne22xgkra7wh9nz6m7dtcjmfn3qx5tyu3gzpqmaey4e2s4qj4pa3s"
    ];
    storageMode = "local";
    localStorageDir = inputs.self + "/secrets/rekeyed/${hostConfig.name}-${config.home.username}";
  };
}
