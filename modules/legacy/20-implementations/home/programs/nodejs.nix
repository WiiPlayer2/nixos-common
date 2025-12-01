{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.nodejs;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
    ];
  };
}
