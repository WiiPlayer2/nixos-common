{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.screenkey;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      screenkey
    ];
  };
}
