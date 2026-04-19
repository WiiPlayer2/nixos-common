{
  # https://nixos.org/manual/nixos/stable/release-notes
  system.stateVersion = "26.05"; # Did you read the comment?

  # Try to avoid using this as much as possible
  programs.nix-ld.enable = true;

  # TODO: this fixes https://github.com/nix-community/home-manager/issues/3113 but it should be put where it is actually required.
  programs.dconf.enable = true;
}
