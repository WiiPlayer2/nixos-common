inputs:
{
  hosts = {
    common.specialArgs = {
      flake-inputs = inputs;
    };
    common.modules = {
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
      ];
      home-manager = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.flatpaks.homeManagerModules.nix-flatpak

        inputs.self.homeModules.default
      ];
    };
  };
}
