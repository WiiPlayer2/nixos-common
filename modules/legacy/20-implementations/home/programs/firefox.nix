{ lib
, config
, ...
}:
with lib;
let
  cfg = config.my.programs.firefox;
in
{
  config = mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}
