{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.power-profiles-daemon.enable = lib.mkIf config.services.tlp.enable (false);

  users.users = {
    root = {
      password = lib.mkVMOverride "vm";
      initialHashedPassword = lib.mkVMOverride null;
    };
    ${config.my.config.mainUser.name} = {
      password = lib.mkVMOverride "vm";
      initialHashedPassword = lib.mkVMOverride null;
    };
  };
}
