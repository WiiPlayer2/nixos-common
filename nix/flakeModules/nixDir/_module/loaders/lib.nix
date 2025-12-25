{ config, ... }:
with config.nixDir.lib;
{
  nixDir.loaders.lib = loaders.haumea;
}
