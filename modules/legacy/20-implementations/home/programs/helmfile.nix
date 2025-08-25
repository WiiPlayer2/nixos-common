{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.helmfile;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      helmfile
    ];
  };
}
