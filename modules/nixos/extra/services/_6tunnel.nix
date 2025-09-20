{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.services._6tunnel;
in
{
  options.services._6tunnel = {
    enable = mkEnableOption "";
    package = mkPackageOption pkgs "_6tunnel" { };

    servers = mkOption {
      type = types.attrsOf (types.submodule (
        { config, ... }:
        {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
            };
            name = mkOption {
              type = types.str;
              readOnly = true;
              default = config._module.args.name;
            };
            localPort = mkOption {
              type = types.port;
            };
            remotePort = mkOption {
              type = types.port;
              default = config.localPort;
            };
            remoteHost = mkOption {
              type = types.str;
            };
          };
        }
      ));
      default = { };
    };
  };

  config = mkIf cfg.enable {
    systemd.services =
      let
        mkService =
          { name, localPort, remotePort, remoteHost, ... }:
          {
            after = [ "network-online.target" ];
            script = "${getExe cfg.package} -d ${builtins.toString localPort} ${remoteHost} ${builtins.toString remotePort}";
            # serviceConfig = {
            #   Restart = "always";
            #   RestartSec = "10s";
            # };
            wantedBy = [ "multi-user.target" ];
          };
        services =
          listToAttrs
            (
              map
                ({ name, value }: {
                  name = "_6tunnel-${name}";
                  value = mkService value;
                })
                (
                  attrsToList
                    (
                      filterAttrs
                        (n: v: v.enable)
                        cfg.servers
                    )
                )
            );
      in
      services;
  };
}
