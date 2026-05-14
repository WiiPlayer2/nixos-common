{ pkgs, ... }:
{
  nix = {
    settings = {
      builders-use-substitutes = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 15d";
    };
  };
}
