{
  nix = {
    settings = {
      builders-use-substitutes = true;
    };
    gc = {
      options = "--delete-older-than 2d";
    };
  };
}
