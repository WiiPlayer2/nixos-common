{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.rclone;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rclone
    ];
  };
}
