{ inputs, ... }:
{
  imports = [
    ./_module
  ];

  virtualisation.vmVariant = inputs.self.nixosModules.virtualisation-qemu-vm;
}
