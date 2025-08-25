{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.samba;
in
{
  # https://nixos.wiki/wiki/Samba
  config = mkIf cfg.enable {
    services = {
      samba = {
        enable = true;
        nmbd.enable = true;
        smbd.enable = true;

        openFirewall = true;

        # Make following entries configurable
        settings = {
          global = {
            "guest account" = "ggj";
            "map to guest" = "bad user";
            "force user" = "ggj";
            # "security" = "share";
            public = "yes";
            "guest ok" = "yes";
          };
          share = {
            path = "/storage/share";
            comment = "Public samba share.";
            browseable = "yes";
            "guest ok" = "yes";
            "read only" = "no";
            "force user" = "ggj";
          };
        };
      };
      samba-wsdd = {
        enable = true;
        discovery = true;
        openFirewall = true;
      };
    };
  };
}
