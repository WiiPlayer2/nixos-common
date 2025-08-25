{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.retroarch;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (retroarch.withCores (cores: with cores; [
        bsnes-mercury-performance
        dolphin
      ]))
    ];
  };
}
