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
        let
          mergeScript = pkgs.writeShellScript "merge" config.mergeWith;
        in
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
                echo "Merging $HM_SOURCE_FILE into $HM_DEST_FILE using ${mergeScript}..."
                cp "$HM_DEST_FILE" "''${HM_DEST_FILE}.bak.tmp"
                if ${mergeScript}; then
                  mv -f "''${HM_DEST_FILE}.bak.tmp" "$HM_DEST_FILE.bak"
                else
                  echo "Merge failed."
                  mv -f "''${HM_DEST_FILE}.bak.tmp" "$HM_DEST_FILE"
                fi
              else
                cp "$HM_SOURCE_FILE" "$HM_DEST_FILE"
              fi
              chmod +w "$HM_DEST_FILE"
            '';
          };
        }
      )
    );
  };
}
