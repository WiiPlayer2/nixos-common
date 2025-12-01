{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.wakatime-cli;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wakatime-cli
    ];
  };
}
