{ lib
, system
, inputs
,
}:
with lib;

# will use `ran` for hosting (smallest closure)

let
  # TODO: make better somehow
  pkgs' = {
    age-plugin-amnesia = { };
    ledmatrix-widgets = { };
    libvirt-autoballoon = { };
    snapcast = { };
    waydroid = { };
    weston = { };
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
      name = "nixos-common";
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
  ];
}
