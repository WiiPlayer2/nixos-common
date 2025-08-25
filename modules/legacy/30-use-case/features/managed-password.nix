{ lib, ... }:
with lib;
{
  options.my.features.managed-password = {
    enable = mkEnableOption "Manage the password of the main user";
    onlyInitial = mkOption {
      description = "Whether only the initial password should be managed. (For images etc.)";
      type = types.bool;
      default = true;
    };

    # TODO: maybe use file instead
    hashedPassword = mkOption {
      description = "The hashed password to use. (`mkpasswd --method=SHA-512 --stdin`)";
      type = types.str;
    };
  };
}
