{ lib, config, ... }:
with lib;
let
  cfg = config.my.programs.envision;
in
{
  config = mkIf cfg.enable {
    programs.envision.enable = true;
  };
}
