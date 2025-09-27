{ lib, inputs, ... }:
{
  flake.overlays.external = lib.fixedPoints.composeManyExtensions [
    inputs.k8s-bridge.overlays.default
    inputs.k8s-toolbox.overlays.default
    inputs.nur.overlays.default
    (_: prev: {
      nueschtos = inputs.nueschtos.packages.${prev.system};

      inherit (inputs.ninelore-monoflake.legacyPackages.${prev.system})
        submarine
        alsa-ucm-conf-cros
        cros-ectool
        ;
    })
  ];
}
