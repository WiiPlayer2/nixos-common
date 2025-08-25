{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.strawberry;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      strawberry
    ];
  };
}
