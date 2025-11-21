{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.useCase.gaming;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      randovania
    ];
  };
}
