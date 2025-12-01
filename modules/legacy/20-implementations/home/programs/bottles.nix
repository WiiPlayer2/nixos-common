{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.bottles;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bottles
    ];
  };
}
