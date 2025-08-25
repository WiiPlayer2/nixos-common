{ lib, flake-parts-lib, config, inputs, ... }:
with lib;
with flake-parts-lib;
let
  genericSubmoduleType = with types; oneOf [
    path
    attrs
    (functionTo attrs)
  ];

  specialArgsOption = mkOption {
    type = types.attrs;
    default = { };
  };

  modulesOption = mkOption {
    type = types.listOf genericSubmoduleType;
    default = [ ];
  };

  hostSubmodule = types.submodule (
    { config, ... }:
    {
      options = {
        name = mkOption {
          readOnly = true;
          type = types.str;
          default = config._module.args.name;
        };

        hostname = mkOption {
          type = types.str;
          default = config.name;
        };

        mainUser = mkOption {
          type = types.str;
        };

        type = mkOption {
          type = types.enum [
            "nixos"
          ];
        };

        specialArgs = specialArgsOption;

        modules = {
          global = modulesOption;
          nixos = modulesOption;
          home-manager = modulesOption;
        };
      };
    }
  );

  getModules =
    type: host:
    config.hosts.common.modules.${type} ++ host.modules.${type};

  mkNixosConfig =
    host:
    let
      extraSpecialArgs = config.hosts.common.specialArgs // host.specialArgs // {
        hostConfig = host;
      };
      globalModules = getModules "global" host;
      configNixosModules = getModules "nixos" host;
      commonHomeModules = config.hosts.common.modules.home-manager;
      sharedHomeModules = globalModules ++ commonHomeModules;
      hostHomeModules = host.modules.home-manager;
      extraNixosModules = [
        inputs.home-manager.nixosModules.default
        {
          home-manager = {
            inherit extraSpecialArgs;

            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = sharedHomeModules;
            users = {
              root = { };
              ${host.mainUser} = {
                imports = hostHomeModules;
              };
            };
          };
          users.users."${host.mainUser}".isNormalUser = true;
        }
      ];
      nixosModules =
        globalModules ++ configNixosModules ++ extraNixosModules;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = extraSpecialArgs;
      modules = nixosModules;
    };

  mkConfigs =
    type: mkConfig:
    let
      hosts =
        filterAttrs
          (n: v: v.type == type)
          config.hosts.config;
      configs =
        mapAttrs
          (n: v: mkConfig v)
          hosts;
    in
    configs;
in
{
  options.hosts = {
    common = {
      specialArgs = specialArgsOption;

      modules = {
        global = modulesOption;
        nixos = modulesOption;
        home-manager = modulesOption;
      };
    };

    config = mkOption {
      type = types.attrsOf hostSubmodule;
    };
  };

  config = {
    flake.nixosConfigurations = mkConfigs "nixos" mkNixosConfig;
  };
}
