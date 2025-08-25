{ lib, config, ... }:
with lib;
let
  cfg = config.my.programs.steam;
in
{
  config = mkIf cfg.enable {
    programs.steam.enable = true;
  };
}
