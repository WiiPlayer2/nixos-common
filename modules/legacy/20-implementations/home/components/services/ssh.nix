{ lib, config, ... }:
with lib;
let
  cfg = config.my.components.services.ssh;
in
{
  config = mkIf (length (attrsToList cfg.authorizedKeys) > 0) {
    home.file."${config.home.homeDirectory}/.ssh/authorized_keys" = {
      onChange = "chmod 600 ${config.home.homeDirectory}/.ssh/authorized_keys";
      text =
        let
          mapKey = item: item.key;
          mappedKeys = map (x: mapKey x.value) (attrsToList cfg.authorizedKeys);
          content = concatStringsSep "\n" mappedKeys;
        in
        content;
    };
  };
}
