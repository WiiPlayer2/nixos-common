{ inputs, ... }:
{
  imports = [
    inputs.delulu-router.nixosModules.default

    inputs.self.nixosModules.service-llama-swap
  ];
}
