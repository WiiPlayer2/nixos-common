{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.delfin;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      delfin
    ];
  };
}
