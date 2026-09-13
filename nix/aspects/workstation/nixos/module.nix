{ inputs, ... }:
{ pkgs, ... }:
{
  imports = [
    inputs.dank-greeter.nixosModules.default

    inputs.self.nixosModules.profile-interactive
  ];

  hardware.graphics.enable = true;
}
