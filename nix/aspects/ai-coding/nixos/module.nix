{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.service-llama-swap
  ];
}
