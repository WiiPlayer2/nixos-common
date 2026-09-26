{ ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkForce
    mkIf
    types
    ;
in
{
  options.home.file = mkOption {
    type = types.attrsOf (
      types.submodule (
        { config, ... }:
        {
          options.mergeWith = mkOption {
            type = types.nullOr types.str;
            default = null;
          };

          config = mkIf (config.mergeWith != null) {
            target = mkForce "${config._module.args.name}.managed";
            onChange = ''
              export HM_SOURCE_FILE="${config.source}"
              export HM_DEST_FILE="${config._module.args.name}"
              if [ -e "$HM_DEST_FILE" ]; then
                ${pkgs.writeShellScript "merge" config.mergeWith}
              else
                cp "$HM_SOURCE_FILE" "$HM_DEST_FILE"
              fi
            '';
          };
        }
      )
    );
  };
}
