{
  lib,
  config,
  flake-inputs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkMerge
    mkIf
    types
    concatMap
    attrsToList
    filter
    map
    fold
    remove
    length
    unique
    ;

  cfg = config.my.specials.distributedBuilds;
in
{
  options.my.specials.distributedBuilds = {
    domain = mkOption {
      description = "The domain of which this machine is a part of.";
      type = types.str;
    };

    allowBuilding = mkEnableOption "Whether this machine should be used in distributed builds.";

    use = mkEnableOption "Whether this machine should use distributed builds.";

    sshPublicKey = mkOption {
      description = "The public key part of the SSH key used for distributed builds.";
      type = types.str;
    };

    sshPrivateKey = mkOption {
      description = "The encrypted private key file of the SSH key used for distributed builds.";
      type = types.path;
    };
  };

  config = mkMerge [
    (mkIf cfg.allowBuilding {
      users.users.build = {
        isSystemUser = true;
        group = "build";
        useDefaultShell = true;
        openssh.authorizedKeys.keys = [ cfg.sshPublicKey ];
      };
      users.groups.build = { };
      nix.settings.trusted-users = [ "build" ];
    })

    (mkIf cfg.use {
      age.secrets.distributedBuildSshPrivateKey = {
        # TODO: configure ssh_config for root
        path = "/root/.ssh/id_ed25519";
        rekeyFile = cfg.sshPrivateKey;
      };

      # nix.distributedBuilds = true;
      nix.buildMachines =
        let
          _getSystems = config: system: [ system ] ++ (config.nix.settings.extra-platforms or [ ]);
          _getEmulatedSystems = config: unique config.boot.binfmt.emulatedSystems;
          _getNativeSystems =
            config: system:
            let
              systems = _getSystems config system;
              emulatedSystems = _getEmulatedSystems config;
            in
            fold (cur: acc: remove cur acc) systems emulatedSystems;

          mkRemote =
            {
              configuration,
              systems,
              speedFactor,
            }:
            {
              inherit systems speedFactor;
              sshUser = "build";
              hostName = configuration.config.networking.hostName;
              supportedFeatures = configuration.config.nix.settings.system-features;
              maxJobs = 32; # should be limited by remote machine for now
            };
          mkNativeRemote =
            configuration:
            mkRemote {
              inherit configuration;
              systems = _getNativeSystems configuration.config configuration.pkgs.stdenv.hostPlatform.system;
              speedFactor = 50;
            };
          mkEmulatedRemote =
            configuration:
            mkRemote {
              inherit configuration;
              systems = _getEmulatedSystems configuration.config;
              speedFactor = 1;
            };
          mkRemotes =
            configuration:
            filter (x: length x.systems > 0) [
              (mkNativeRemote configuration)
              (mkEmulatedRemote configuration)
            ];
          configurations = filter (
            { value, ... }:
            (value.config.my.specials.distributedBuilds.allowBuilding or false)
            && value.config.my.specials.distributedBuilds.domain == cfg.domain
            && value.config.networking.hostName != config.networking.hostName
          ) (attrsToList flake-inputs.self.nixosConfigurations);
          remotes = concatMap ({ value, ... }: mkRemotes value) configurations;
        in
        remotes;
    })
  ];
}
