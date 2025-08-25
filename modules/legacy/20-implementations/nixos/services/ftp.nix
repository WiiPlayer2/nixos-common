{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.ftp;
in
{
  config = mkIf cfg.enable {
    services.vsftpd.enable = true;
  };
}
