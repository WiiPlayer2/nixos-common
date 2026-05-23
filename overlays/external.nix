{ lib, inputs, ... }:
{
  flake.overlays.external = lib.fixedPoints.composeManyExtensions [
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
        }).emuhawk;

      # openspec is garbage because there is no overlay and
      # it uses nodejs_20 which is EOL
      openspec = inputs.openspec.packages.${prev.stdenv.hostPlatform.system}.default.overrideAttrs (
        finalAttrs: prevAttrs: {
          nativeBuildInputs = with final; [
            nodejs_22
            npmHooks.npmInstallHook
            pnpmConfigHook
            pnpm_9
          ];
        }
      );

      # again no overlay T_T
      inherit (inputs.erosanix.packages.${prev.stdenv.hostPlatform.system})
        mkwindowsapp-tools
        ;
    })
  ];
}
