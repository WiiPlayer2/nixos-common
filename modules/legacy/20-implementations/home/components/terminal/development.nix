{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.terminal.development;
in
{
  config =
    with lib;
    mkMerge [
      (mkIf cfg.pmbootstrap {
        home.packages = with pkgs; [
          # pmbootstrap
          multipath-tools
          openssl
          gnumake
          gcc
          flex
          bison
        ];
      })
    ];
}
