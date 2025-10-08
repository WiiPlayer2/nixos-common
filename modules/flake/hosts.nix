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

  commonOptions = {
    specialArgs = specialArgsOption;

    overlays = mkOption {
      type = with types; listOf (functionTo (functionTo attrs));
      default = [];
    };

    modules = {
      global = modulesOption;
      nixos = modulesOption;
      home-manager = modulesOption;
      nix-on-droid = modulesOption;
    };
  };

  hostSubmodule = types.submodule (
    { config, ... }:
    {
      options = commonOptions // {
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
            "nix-on-droid"
          ];
        };

        # TODO: implement for nixos
        system = mkOption {
          type = types.str;
        };
      };
    }
  );

  getModules =
    type: host:
    let
      globalModules = getModules "global" host;
      typeModules = config.hosts.common.modules.${type} ++ host.modules.${type};
      modules = typeModules ++ (optionals (type != "global") globalModules);
    in
    modules;

  getOverlays =
    host:
    config.hosts.common.overlays ++ host.overlays;

  getSpecialArgs =
    host:
    config.hosts.common.specialArgs // host.specialArgs // {
      hostConfig = host;
    };

  mkNixosConfig =
    host:
    let
      extraSpecialArgs = getSpecialArgs host;
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

  mkNixOnDroidConfig =
    host:
    let
      pkgs = import inputs.nixpkgs {
        inherit (host) system;
        overlays = getOverlays host;
      };
      extraSpecialArgs = getSpecialArgs host;
      nixOnDroidModules = getModules "nix-on-droid" host;
      homeModules = getModules "home-manager" host;
    in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      inherit pkgs extraSpecialArgs;
      modules = [
        {
          home-manager = {
            inherit extraSpecialArgs;

            backupFileExtension = "bak";
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = homeModules;
            config = { };
          };

          user.userName = host.mainUser;
        }
      ] ++ nixOnDroidModules;
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
    common = commonOptions;

    config = mkOption {
      type = types.attrsOf hostSubmodule;
    };
  };

  config = {
    flake.nixosConfigurations = mkConfigs "nixos" mkNixosConfig;
    flake.nixOnDroidConfigurations = mkConfigs "nix-on-droid" mkNixOnDroidConfig;
  };
}
