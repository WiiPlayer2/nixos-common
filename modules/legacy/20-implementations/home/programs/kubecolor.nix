{ lib, config, ... }:
with lib;
let
  cfg = config.my.programs.kubecolor;
in
{
  config = mkIf cfg.enable {
    programs.kubecolor = {
      enable = true;
      enableAlias = true;
    };
  };
}
