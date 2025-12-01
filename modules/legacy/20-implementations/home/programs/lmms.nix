{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.lmms;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lmms
    ];
  };
}
