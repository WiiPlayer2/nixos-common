{ lib, config, ... }:
with lib;
let
  cfg = config.my.programs.obs-studio;
in
{
  config = mkIf cfg.enable {
    programs.obs-studio.enable = true;
  };
}
