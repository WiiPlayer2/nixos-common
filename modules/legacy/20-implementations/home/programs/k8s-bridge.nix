{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.k8s-bridge;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      k8s-bridge
    ];
  };
}
