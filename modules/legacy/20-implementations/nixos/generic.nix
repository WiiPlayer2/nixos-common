{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Try to avoid using this as much as possible
  programs.nix-ld.enable = true;

  # TODO: this fixes https://github.com/nix-community/home-manager/issues/3113 but it should be put where it is actually required.
  programs.dconf.enable = true;
}
