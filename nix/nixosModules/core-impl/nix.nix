{ lib, ... }:
let
  inherit (lib)
    mkDefault
    ;
in
{
  nix = {
    settings.trusted-users = [
      "@wheel"
    ];
    gc.automatic = mkDefault true;
  };
}
