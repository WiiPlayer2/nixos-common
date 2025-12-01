{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.kubernetes-helm;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (wrapHelm kubernetes-helm {
        plugins = with kubernetes-helmPlugins; [
          helm-diff
        ];
      })
    ];
  };
}
