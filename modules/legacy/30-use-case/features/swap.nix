{ lib, config, ... }:
with lib;
let
  cfg = config.my.features.swap;
in
{
  options.my.features.swap = {
    enable = mkEnableOption "Swap space for moving memory pages to disk";
  };

  config = mkIf cfg.enable {
    my.services.swapspace.enable = true;
  };
}
