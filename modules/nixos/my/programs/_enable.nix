{ config, ... }:
{
  programs = {
    sway.enable = config.services.xserver.enable;
  };
}
