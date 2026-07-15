{ inputs, ... }:
{ pkgs, ... }:
{
  imports = [
    inputs.dms.nixosModules.greeter

    inputs.self.nixosModules.profile-interactive
  ];

  hardware.graphics.enable = true;
}
