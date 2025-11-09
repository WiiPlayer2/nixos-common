{
  flake.overlays.overrides =
    final: prev: {
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

      poptracker = prev.poptracker.overrideAttrs (finalAttrs: prevAttrs: {
        installPhase =
          let
            elaboratedSystem = prev.lib.systems.elaborate prev.system;
            arch = elaboratedSystem.qemuArch;
            fixedInstallPhase = prev.lib.replaceStrings [ "x86_64" ] [ arch ] prevAttrs.installPhase;
          in
          fixedInstallPhase;

        meta = prevAttrs.meta // {
          platforms = prevAttrs.meta.platforms ++ [
            "aarch64-linux"
          ];
        };
      });
    };
}
