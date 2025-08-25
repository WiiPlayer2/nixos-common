{ lib, config, ... }:
with lib;
let
  cfg = config.my.secrets;
in
{
  config = {
    age.secrets = mapAttrs
      (name: value: {
        inherit (value)
          path
          owner
          ;
        rekeyFile = value.file;
      })
      cfg.files;
    users.users.${config.my.config.mainUser.name}.extraGroups = [
      "keys"
    ];
  };
}
