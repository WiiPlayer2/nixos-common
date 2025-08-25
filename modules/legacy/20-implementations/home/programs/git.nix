{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.git;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
    ];
    programs.git = {
      enable = true;
    };
  };
}
