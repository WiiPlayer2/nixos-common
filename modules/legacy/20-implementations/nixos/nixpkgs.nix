{ lib, config, ... }:
with lib;
let
  cfg = config.my.config.nixpkgs.config;
  mkAllowPkgs =
    pkgs:
    mkIf ((length pkgs) > 0) {
      permittedInsecurePackages = pkgs;
    };
in
{
  config.nixpkgs.config = mkMerge [
    cfg
    (mkAllowPkgs config.my.meta.allowedInsecurePackages)
  ];
}
