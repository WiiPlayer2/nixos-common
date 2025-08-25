{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.keyviz;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      keyviz
    ];
  };
}
