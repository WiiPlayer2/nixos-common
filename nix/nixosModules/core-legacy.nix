_: {
  age = {
    imprinting = {
      enable = true;
      manual = true;
      target = "/etc/ssh/ssh_host_ed25519_key";
    };

    rekey.storageMode = "local";
  };

  services.openssh.enable = true;

  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
}
