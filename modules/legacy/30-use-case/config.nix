{ lib, ... }:
with lib;
{
  options.my.config = {
    i18n = {
      language = mkOption {
        description = "Language";
        type = types.str;
      };
      formats = mkOption {
        description = "Formats";
        type = types.str;
      };
    };

    time = {
      timeZone = mkOption {
        description = "Time zone";
        type = types.str;
      };
    };

    keyboard = {
      layout = mkOption {
        description = "Keyboard layout";
        type = types.str;
      };
    };

    defaultShell = mkOption {
      description = "Default shell";
      type = types.package;
    };

    mainUser = {
      name = mkOption {
        description = "Main user name";
        type = types.str;
      };

      description = mkOption {
        description = "Main user description";
        type = with types; nullOr str;
        default = null;
      };
    };

    nix = mkOption {
      description = "Nix configuration";
      type = types.anything;
    };

    nixpkgs = {
      config = mkOption {
        description = "The nixpkgs configuration";
        type = types.attrs;
        default = { };
      };
    };

    hostname = mkOption {
      description = "The machine hostname";
      type = types.str;
    };

    hostPubkey = mkOption {
      description = "The machine SSH host public key";
      type = types.nullOr types.str;
      default = null;
    };
  };
}
