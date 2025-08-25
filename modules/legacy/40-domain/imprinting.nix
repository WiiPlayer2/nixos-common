{ lib, ... }:
with lib;
{
  options.my.imprinting = {
    # NOTE: maybe the names should be the target paths
    files = mkOption {
      description = "Encrypted files which will be decrypted from store if they do not exist using a temporary available key (like a YubiKey)";
      type = types.attrsOf (
        types.submodule (
          { config, ... }:
          {
            options = {
              name = mkOption {
                description = "Name of this entry";
                readOnly = true;
                type = types.str;
                default = config._module.args.name;
              };

              file = mkOption {
                description = "The path to the encrypted file. Should be in nix store.";
                type = types.path;
              };

              path = mkOption {
                description = "The path for the decrypted file.";
                type = types.path;
              };

              script = mkOption {
                description = "A script which should be run after the file has been imprinted.";
                type = types.str;
                default = "";
              };

              mode = mkOption {
                description = "The file permission mode of the decrypted file";
                type = types.str;
                default = "0400";
              };
            };
          }
        )
      );
      default = { };
    };
  };
}
