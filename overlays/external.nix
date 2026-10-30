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
      # inherit (inputs.opencode.packages.${prev.stdenv.hostPlatform.system})
      #   opencode
      #   opencode-desktop
      #   ;

      opencode =
        let
          upstreamOpencode = inputs.opencode.packages.${prev.stdenv.hostPlatform.system}.opencode;
        in
        upstreamOpencode.overrideAttrs (
          finalAttrs: prevAttrs: {
            node_modules = prevAttrs.node_modules.overrideAttrs {
              outputHash = "sha256-jldGJwsB717N5tOoeWQlDrpiKM6EAjMbLXV0yYE0T5c=";
            };
          }
        );

      opencode-desktop =
        let
          upstreamOpencode = inputs.opencode.packages.${prev.stdenv.hostPlatform.system}.opencode-desktop;
        in
        (upstreamOpencode.override {
          inherit (final) opencode;
        }).overrideAttrs
          (
            finalAttrs: prevAttrs: {
              # desktop.nix inherits node_modules from the opencode arg at eval time, which
              # is the upstream derivation; re-point it at the overridden one so the patched
              # node_modules hash is the one actually built.
              node_modules = final.opencode.node_modules;
              # desktop.nix bundles the CLI into $OPENCODE_CLI_DIST during buildPhase, but
              # build.ts hardcodes ../cli/dist and throws for prod channel builds when that
              # directory is absent. Honour the env var desktop.nix already populates.
              patches = (prevAttrs.patches or [ ]) ++ [ ./opencode-desktop-cli-dist.patch ];
            }
          );
    })
  ];
}
