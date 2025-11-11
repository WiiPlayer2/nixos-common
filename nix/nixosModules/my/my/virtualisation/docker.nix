{ lib, config, ... }:
let
  cfg = config.virtualisation.docker;
in
{
  config = lib.mkIf cfg.enable {
    users.users.${config.my.config.mainUser.name}.extraGroups = [
      "docker"
    ];
  };
}
