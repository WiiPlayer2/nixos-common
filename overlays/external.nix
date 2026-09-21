{ lib, inputs, ... }:
let
  inherit (lib.fixedPoints)
    composeManyExtensions
    ;
in
{
  flake.overlays.external = composeManyExtensions [
    inputs.k8s-bridge.overlays.default
    inputs.k8s-toolbox.overlays.default
    inputs.nur.overlays.default

    (final: prev: {
      nueschtos = inputs.nueschtos.packages.${prev.stdenv.hostPlatform.system};

      inherit (inputs.ninelore-monoflake.legacyPackages.${prev.stdenv.hostPlatform.system})
        submarine
        alsa-ucm-conf-cros
        cros-ectool
        ;

      bizhawk =
        (import inputs.bizhawk {
          system = prev.stdenv.hostPlatform.system;
          pkgs = final;
        }).emuhawk;

      # again no overlay T_T
      inherit (inputs.erosanix.packages.${prev.stdenv.hostPlatform.system})
        mkwindowsapp-tools
        ;

      # issues with overlay due to some nodejs incompatibilities
      inherit (inputs.opencode.packages.${prev.stdenv.hostPlatform.system})
        opencode
        opencode-desktop
        ;
    })
  ];
}
