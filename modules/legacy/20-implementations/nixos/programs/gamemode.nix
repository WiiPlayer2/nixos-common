{ lib, config, ... }:
with lib;
let
  cfg = config.my.programs.gamemode;
in
{
  config = mkIf cfg.enable {
    programs.gamemode.enable = true;
  };
}
