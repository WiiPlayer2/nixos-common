inputs:
{
  hosts = {
    common.specialArgs = {
      flake-inputs = inputs;
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
}
