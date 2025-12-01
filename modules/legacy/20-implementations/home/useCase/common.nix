{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.useCase.common.banking;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      banking
    ];
  };
}
