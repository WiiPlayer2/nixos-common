{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.my.programs.thunderbird;
  accounts = config.my.accounts.email;

  profileName = "default";
in
{
  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      package = pkgs.unstable.thunderbird;
      profiles."${profileName}" = {
        isDefault = true;
      };
    };

    my.startup.thunderbird.command = "thunderbird";

    # TODO: add warning if an account is configured
    # Doesn't really work as the account is not shown in thunderbird and if one is added it's gone after a restart
    # accounts.email.accounts =
    #   mapAttrs
    #   (name: x: {
    #     thunderbird = {
    #       enable = true;
    #       profiles = [
    #         profileName
    #       ];
    #     };
    #   })
    #   accounts;
  };
}
