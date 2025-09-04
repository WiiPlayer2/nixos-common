inputs:
args:
{
  hosts = {
    common.specialArgs = {
      flake-inputs = args.inputs;
    };
    common.modules = {
      global = [
        # Legacy compatibility
        (
          { hostConfig, ... }:
          {
            my.config.mainUser.name = hostConfig.mainUser;
            my.config.hostname = hostConfig.hostname;
            my.meta.configurationNames.nixos = hostConfig.name;
          }
        )
      ];
      nixos = [
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.sops-nix.nixosModules.sops
        inputs.NixVirt.nixosModules.default
        inputs.stylix.nixosModules.stylix
        inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
        inputs.agenix.nixosModules.default
        inputs.agenix-rekey.nixosModules.default
        inputs.disko.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.comin.nixosModules.comin
        inputs.nixos-generators.nixosModules.all-formats

        inputs.self.nixosModules.default
        {
          nixpkgs.overlays = [
            inputs.self.overlays.default
          ];
        }
      ];
      home-manager = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.flatpaks.homeManagerModules.nix-flatpak

        inputs.self.homeModules.default
      ];
    };
  };

  perSystem =
    { inputs', self', lib, pkgs, system, ... }:
      with lib;
      {
        inherit (inputs'.common)
          packages
          legacyPackages;

        agenix-rekey.nixosConfigurations = args.inputs.self.nixosConfigurations;
        pre-commit.settings.hooks = {
          update-common = {
            enable = true;
            entry = "nix flake update common";
            pass_filenames = false;
          };
        };
        apps =
          let
            commonApps = inputs.self.apps.${system};
            startsWith =
              str: value:
              (builtins.match "${str}.*" value) != null;
            isCiApp = startsWith "__ci__";
            isRepoApp = startsWith "__repo__";
            isDomainApp = n: isCiApp n || isRepoApp n;
            domainApps =
              filterAttrs
                (n: v: isDomainApp n)
                commonApps;
          in
          domainApps;
      };
}
