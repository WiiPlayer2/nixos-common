{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.terminal;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      programs.bash = {
        enable = true;
        initExtra = lib.concatStrings [
          "eval \"$(starship init bash)\"\n"
        ];
      };
    };
}
