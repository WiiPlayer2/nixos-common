{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.my.components.terminal;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      programs.git = {
        enable = true;
      };
    };
}
