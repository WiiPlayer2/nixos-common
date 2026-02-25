{ config, ... }:
with config.nixDir.lib;
{
  nixDir.loaders.lib = presets.haumea;
}
