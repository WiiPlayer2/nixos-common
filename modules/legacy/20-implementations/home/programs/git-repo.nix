{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.git-repo;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git-repo
    ];
  };
}
