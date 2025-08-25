{ lib, config, ... }:
with lib;
let
  cfg = config.my.services.swapspace;
in
{
  config = mkIf cfg.enable {
    services.swapspace = {
      enable = true;
    };
  };
}
