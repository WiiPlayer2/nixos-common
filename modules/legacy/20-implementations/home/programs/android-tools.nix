{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.android-tools;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      android-tools
    ];
  };
}
