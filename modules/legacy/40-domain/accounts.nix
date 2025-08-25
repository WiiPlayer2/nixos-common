{ lib, ... }:
with lib;
let
  emailType = types.str; # TODO: for now
in
{
  options.my.accounts = {
    email = mkOption {
      description = "E-Mail accounts";
      type =
        with types;
        attrsOf (submodule {
          options = {
            enable = mkOption {
              description = "Whether this e-mail account is enabled";
              type = types.bool;
              default = true;
            };
            isPrimary = mkEnableOption "Whether this account is the primary acccount";
            address = mkOption {
              description = "The e-mail address";
              type = emailType;
            };
            realName = mkOption {
              description = "The real name for this e-mail account";
              type = types.str;
            };
          };
        });
      default = { };
    };
  };
}
