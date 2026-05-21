{ inputs, ... }:
{ pkgs, ... }:
{
  imports = [
    inputs.dms.nixosModules.greeter
  ];

  hardware.graphics.enable = true;
}
