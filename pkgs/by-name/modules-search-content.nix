{ lib
, system
, inputs

, formats
}:
with lib;

# will use `ran` for hosting (smallest closure)

let
  # TODO: make better somehow
  pkgs' = {
    inherit formats;

    age-plugin-amnesia = { };
    ledmatrix-widgets = { };
    libvirt-autoballoon = { };
    snapcast = { };
    waydroid = { };
    weston = { };
    davmail = { };
    nix-web = { };
  };
in
inputs.nueschtos.packages.${system}.mkMultiSearch {
  scopes = [
    {
      name = "NixOS";
      urlPrefix = "https://github.com/NixOS/nixpkgs/tree/25.05/";
      optionsJSON = (import "${inputs.nixpkgs}/nixos/release.nix" { }).options + /share/doc/nixos/options.json;
    }

    {
      name = "nixos-common (NixOS)";
      urlPrefix = "https://github.com/WiiPlayer2/nixos-common/tree/main/";
      specialArgs = {
        pkgs = pkgs';
      };
      modules = [
        inputs.self.nixosModules.agenix-imprinting
        inputs.self.nixosModules.extra
        # inputs.self.nixosModules.legacy
        inputs.self.nixosModules.my
        inputs.self.nixosModules.profile-workstation
        inputs.self.nixosModules.wireplumber-roles
      ];
    }

    {
      name = "nixos-common (Home-Manager)";
      urlPrefix = "https://github.com/WiiPlayer2/nixos-common/tree/main/";
      specialArgs = {
        pkgs = pkgs';
      };
      modules = [
        inputs.self.homeModules.extra
        inputs.self.homeModules.legacy
        inputs.self.homeModules.legacy-standalone
        inputs.self.homeModules.my
        inputs.self.homeModules.profile-gaming
        inputs.self.homeModules.profile-workstation
        inputs.self.homeModules.program-archipelago
        inputs.self.homeModules.program-bizhawk
        inputs.self.homeModules.program-dolphin-emu
        inputs.self.homeModules.program-poptracker
      ];
    }

    # TODO: nix-on-droid modules needed
    {
      name = "nixos-common (nix-on-droid)";
      urlPrefix = "https://github.com/WiiPlayer2/nixos-common/tree/main/";
      specialArgs = {
        pkgs = pkgs';
      };
      modules = [
        # inputs.self.nixOnDroidModules.extra 
        # inputs.self.nixOnDroidModules.legacy
        inputs.self.nixOnDroidModules.my
        # inputs.self.nixOnDroidModules.nixosCompat
        inputs.self.nixOnDroidModules.profile-base
      ];
    }

    # {
    #   name = "Inputs (NixOS)";
    #   modules = [
    #     inputs.lanzaboote.nixosModules.lanzaboote
    #     inputs.sops-nix.nixosModules.sops
    #     inputs.NixVirt.nixosModules.default
    #     inputs.stylix.nixosModules.stylix
    #     inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    #     inputs.agenix.nixosModules.default
    #     inputs.agenix-rekey.nixosModules.default
    #     inputs.disko.nixosModules.default
    #     inputs.home-manager.nixosModules.home-manager
    #     inputs.comin.nixosModules.comin
    #     inputs.nixos-generators.nixosModules.all-formats
    #   ];
    # }
  ];
}
