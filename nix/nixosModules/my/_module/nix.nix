{ lib, ... }:
{
  nix = {
    settings = {
      builders-use-substitutes = true;
    };
    gc = {
      # Don't run automatically anymore
      # TODO: enable automatic runs on unattended systems,
      # alternatively enable by default but explicitly disable
      # on workstations or interactive/attended systems
      automatic = lib.mkDefault true;
      options = "--delete-older-than 15d";
    };
  };
}
