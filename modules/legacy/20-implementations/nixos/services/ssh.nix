{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.ssh;
  mainUser = config.my.config.mainUser.name;
  identity = config.my.identity;
in
{
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
    };

    # TODO: this should probably be migrated to home-manager
    users.users =
      let
        userCfg = {
          openssh.authorizedKeys.keys = map (x: x.value.key) (
            filter (x: x.value.enable) (attrsToList identity.ssh)
          );
        };
      in
      {
        root = userCfg;
        "${mainUser}" = userCfg;
      };
  };
}
