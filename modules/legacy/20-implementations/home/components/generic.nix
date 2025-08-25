{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfgOs = config.my.os;
in
{
  config = {
    # https://github.com/nix-community/home-manager/tree/master/docs/release-notes
    home.stateVersion = "24.05";

    # See https://nixos.wiki/wiki/Home_Manager (Usage on non-NixOS Linux)
    targets.genericLinux.enable = cfgOs.type != "nixos" && cfgOs.type != "nix-on-droid";

    home.packages = with pkgs; [
      (mkIf (cfgOs.type != "nixos") nixgl.nixGLDefault)
    ];
  };
}
