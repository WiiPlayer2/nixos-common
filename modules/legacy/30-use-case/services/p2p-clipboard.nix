{ lib, ... }:
with lib;
{
  options.my.services.p2p-clipboard = {
    enable = mkEnableOption "Enable p2p-clipboard service";
    port = mkOption {
      description = "The port to listen on";
      type = types.port;
      default = 44999;
    };
  };
}
