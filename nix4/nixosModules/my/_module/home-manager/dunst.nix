{ lib, config, ... }:
with lib;
{
  home-manager.sharedModules = [
    {
      services.dunst.enable = mkDefault config.services.xserver.enable;
    }
  ];
}
