{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.my.programs.kubecolor;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
    ];

    programs.kubecolor = {
      enable = true;
      enableAlias = true;
    };
  };
}
