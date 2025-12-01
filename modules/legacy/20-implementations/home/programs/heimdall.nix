{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.heimdall;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      heimdall
    ];
  };
}
