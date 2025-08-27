{ lib, inputs, ... }:
{
  flake.overlays.external = lib.fixedPoints.composeManyExtensions [
    inputs.k8s-bridge.overlays.default
    inputs.k8s-toolbox.overlays.default
  ];
}
