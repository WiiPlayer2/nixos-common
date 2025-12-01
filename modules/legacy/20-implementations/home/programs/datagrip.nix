{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.datagrip;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jetbrains.datagrip
    ];
  };
}
