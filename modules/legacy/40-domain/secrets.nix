{ lib, config, ... }:
with lib;
let
  cfg = config.my.secrets;
in
{
  options.my.secrets = {
    store = mkOption {
      description = "The path to where secrets should be available at by default.";
      type = types.path;
      default = "/run/secrets-age";
    };
    files = mkOption {
      description = "The secrets that are to be used in this configuration.";
      type = types.attrsOf (
        types.submodule (
          { config, ... }:
          {
            options = {
              name = mkOption {
                description = ''
                  Name of the file used in {option}`my.secrets.store`
                '';
                type = types.str;
                default = config._module.args.name;
                defaultText = literalExpression "config._module.args.name";
              };

              file = mkOption {
                description = "The path to the encrypted file. Should be in nix store.";
                type = types.path;
              };

              path = mkOption {
                description = "The path to the decrypted file at runtime.";
                type = types.path;
                default = "${cfg.store}/${config.name}";
              };

              owner = mkOption {
                description = "The owner of the decrypted file.";
                type = types.str;
                default = "0";
              };
            };
          }
        )
      );
      default = { };
    };
  };
}
