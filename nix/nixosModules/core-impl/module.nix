{ inputs, ... }:
{ lib, pkgs, ... }:
let
  inherit (lib) getExe';
in
{
  imports = [
    inputs.self.nixosModules.lix
  ];

  age = {
    imprinting = {
      enable = true;
      manual = true;
      target = "/etc/ssh/ssh_host_ed25519_key";
    };

    rekey.storageMode = "local";
  };

  services.openssh.enable = true;

  nix.settings = {
    extra-experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operator"
    ];

    # specific to Lix
    extra-deprecated-features = [
      "broken-string-indentation"
      "rec-set-dynamic-attrs"
      "broken-string-escape"
      "or-as-identifier"
    ];
  };

  nixpkgs.overlays = [
    inputs.self.overlays.default
  ];

  home-manager = {
    # backupFileExtension = "bak";
    backupCommand = getExe' pkgs.trash-cli "trash-put"; # Put into trash
    useGlobalPkgs = true;
    useUserPackages = true;
    users.root = { };
    sharedModules = [
      inputs.self.homeModules.core
    ];
  };

  networking.networkmanager.enable = true;

  virtualisation.vmVariant = inputs.self.nixosModules.virtualisation-qemu-vm;

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;
}
