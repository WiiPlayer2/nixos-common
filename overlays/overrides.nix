{ lib, ... }:
with lib;
{
  flake.overlays.overrides =
    final: prev:
    optionalAttrs (!prev ? __common_is_applied) {
      # TODO: this is just a "temporary" workaround while the overlay is imported via the legacy hosts flake module and the newer core nixos module
      __common_is_applied = true;

      python312 = prev.python312.override {
        packageOverrides = pfinal: pprev: {
          # Used for wyoming-satellite; should probably be fixed better
          # pysilero-vad = pprev.pysilero-vad.overrideAttrs (prevPkg: {
          #   # version = "2.1.1";
          #   # src = prev.fetchFromGitHub {
          #   #   owner = "rhasspy";
          #   #   repo = "pysilero-vad";
          #   #   tag = "v2.1.1";
          #   #   hash = "sha256-zxvYvPnL99yIVHrzbRbKmTazzlefOS+s2TAWLweRSYE=";
          #   # };
          #   # doCheck = false;
          #   dontUsePytestCheck = true;
          #   pythonImportsCheck = [ ];
          #   meta = prevPkg.meta // {
          #     broken = false;
          #   };
          # });
        };
      };

      poptracker = prev.unstable.poptracker.overrideAttrs (
        finalAttrs: prevAttrs: {
          installPhase =
            let
              elaboratedSystem = prev.lib.systems.elaborate prev.stdenv.hostPlatform.system;
              arch = elaboratedSystem.qemuArch;
              fixedInstallPhase = prev.lib.replaceStrings [ "x86_64" ] [ arch ] prevAttrs.installPhase;
            in
            fixedInstallPhase;

          meta = prevAttrs.meta // {
            platforms = prevAttrs.meta.platforms ++ [
              "aarch64-linux"
            ];
          };
        }
      );

      picom = prev.picom.overrideAttrs (
        finalAttrs: prevAttrs: {
          patches = prevAttrs.patches or [ ] ++ [
            # see https://github.com/yshui/picom/issues/1511
            (final.fetchpatch {
              url = "https://github.com/yshui/picom/commit/676196359c15bb654696b05700330685db914710.patch";
              hash = "sha256-YbpGL6FvXdIh3N5zJ1oJJc/YOLLVQL0Jlp0LetpnecA=";
            })
          ];
        }
      );

      openldap =
        let
          brokenVersion = "2.6.13";
          currentVersion = prev.openldap.version;

          patchedPkg = prev.openldap.overrideAttrs (_: {
            doCheck = !prev.stdenv.hostPlatform.isi686;
          });
        in
        if versionOlder brokenVersion currentVersion then
          warn ''
            openldap is patched from ${brokenVersion} up but nixpkgs now ships ${currentVersion}.

            i686 test-suite workaround might no be required anymore:
              https://github.com/NixOS/nixpkgs/issues/513245
              https://github.com/NixOS/nixpkgs/pull/429119
          '' patchedPkg
        else if brokenVersion == currentVersion then
          patchedPkg
        else
          prev.openldap;
    };
}
