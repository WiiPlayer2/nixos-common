{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.managed-password;
in
{
  config = mkIf cfg.enable {
    users.users."${config.my.config.mainUser.name}" = mkMerge [
      (mkIf cfg.onlyInitial {
        initialHashedPassword = cfg.hashedPassword;
      })
      (mkIf (!cfg.onlyInitial) {
        hashedPassword = cfg.hashedPassword;
      })
    ];
  };
}
