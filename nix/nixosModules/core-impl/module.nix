{ inputs, ... }:
{
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
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    users.root = { };
    sharedModules = [
      inputs.self.homeModules.core
    ];
  };
}
