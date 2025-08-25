{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.feishin;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unstable.feishin
    ];
  };
}
