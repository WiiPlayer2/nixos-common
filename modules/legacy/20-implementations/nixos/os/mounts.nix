{ lib, config, ... }:
with lib;
let
  cfg = config.my.os.mounts;
in
{
  config = {
    boot.supportedFilesystems = [
      "ntfs"
    ];

    fileSystems = mapAttrs (
      mountPath: cfg:
      mkIf cfg.enable {
        device = cfg.device;
        fsType = mkIf (cfg.type != null) cfg.type;
        options = mkIf (cfg.options != null) cfg.options;
      }
    ) cfg;
  };
}
