{ lib, ... }:
with lib;
{
  flake.overlays.overrides = final: prev: {
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

    # itch.io fix
    # lutris-unwrapped =
    #   assert prev.unstable.lutris-unwrapped.version == "0.5.19";
    #   assert prev.lutris-unwrapped.version == "0.5.19";
    #   prev.lutris-unwrapped.overrideAttrs {
    #     version = "2d0244a";
    #     src = final.fetchFromGitHub {
    #       owner = "lutris";
    #       repo = "lutris";
    #       rev = "2d0244aa28fb05aebebf3f0c1ed2198cd23e77b3";
    #       hash = "sha256-IKiYlbC6zyGBmv49yTz3/ER6zg5VoQazOzVmqayWEuo=";
    #     };
    #   };

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
  };
}
