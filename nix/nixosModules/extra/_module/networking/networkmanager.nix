{ lib, config, ... }:
with lib;
let
  cfg = config.networking.networkmanager;
in
{
  options.networking.networkmanager = {
    ensureProfiles = {
      wifi = mkOption {
        type = types.attrsOf (
          types.submodule (
            { config, ... }:
            {
              options = {
                ssid = mkOption {
                  readOnly = true;
                  type = types.str;
                  default = config._module.args.name;
                };

                psk = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };

                priority = mkOption {
                  type = types.int;
                  default = 0;
                };
              };
            }
          )
        );
        default = { };
      };
    };
  };

  config = {
    networking.networkmanager.ensureProfiles.profiles =
      let
        mkWifiProfile =
          {
            ssid,
            psk,
            priority,
          }:
          {
            connection = {
              id = ssid;
              type = "wifi";
              autoconnect = mkDefault true;
              autoconnect-priority = priority;
            };
            ipv4.method = "auto";
            ipv6.method = "auto";
            wifi = {
              inherit ssid;
              mode = "infrastructure";
            };
            wifi-security = {
              inherit psk;
              auth-alg = "open";
              key-mgmt = "wpa-psk";
            };
          };
        wifiProfiles = mapAttrs (n: mkWifiProfile) cfg.ensureProfiles.wifi;
        allProfiles = wifiProfiles;
      in
      allProfiles;
  };
}
