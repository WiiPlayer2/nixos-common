{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.hermes-agent.overlays.default
  ];
}
