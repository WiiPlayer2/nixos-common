{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.ryujinx;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ryubing
    ];
  };
}
