{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.server;
in
{
  options.my.useCase.server =
    let
      self = config.my.useCase.server;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Server";
      options = {
        git = mkSub "Git server";
        fileshare = mkSub "Fileshare server";
        vpn = mkSubGroup {
          description = "VPN server";
          options =
            let
              self = config.my.useCase.server.vpn;
              mkSub = mkSubUseCaseOption self;
              mkSubGroup = mkSubGroupUseCaseOption self;
            in
            {
              softether = mkSub "SoftEther VPN server";
            };
        };
        k8s = mkSubGroup {
          description = "Kubernetes cluster";
          options =
            let
              self = config.my.useCase.server.k8s;
              mkSub = mkSubUseCaseOption self;
              mkSubGroup = mkSubGroupUseCaseOption self;
            in
            {
              server = mkSub "Server";
              agent = mkSubGroup {
                description = "Agent";
                options = {
                  serverAddr = mkOption {
                    description = "Server address";
                    type = types.str;
                  };
                  tokenFile = mkOption {
                    description = "Token file";
                    type = types.path;
                  };
                  allowedPorts =
                    let
                      mkPortsOption =
                        description:
                        mkOption {
                          inherit description;
                          type = types.listOf types.port;
                          default = [ ];
                        };
                    in
                    {
                      tcp = mkPortsOption "TCP";
                      udp = mkPortsOption "UDP";
                    };
                };
              };
            };
        };
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    (mkIf cfg.git.enable {
      my.services.gitea.enable = true;
    })
    (mkIf cfg.fileshare.enable {
      my.services.samba.enable = true;
      my.services.ftp.enable = true;
    })
    (mkIf cfg.vpn.softether.enable {
      my.services = {
        softether-vpn-server.enable = true;
      };
    })
  ];
}
