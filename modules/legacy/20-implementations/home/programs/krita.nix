{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.krita;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      krita
    ];
  };
}
