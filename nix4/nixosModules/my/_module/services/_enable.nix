{ lib, config, ... }:
with lib;
{
  services = {
    openssh.enable = true;
    swapspace.enable = true;
    fwupd.enable = true;
  };
}
