{
  flake.overlays.overrides =
    final: prev: {
      python312 = prev.python312.override {
        packageOverrides = pfinal: pprev: {
          pysilero-vad = pprev.pysilero-vad.overrideAttrs (prevPkg: {
            # version = "2.1.1";
            # src = prev.fetchFromGitHub {
            #   owner = "rhasspy";
            #   repo = "pysilero-vad";
            #   tag = "v2.1.1";
            #   hash = "sha256-zxvYvPnL99yIVHrzbRbKmTazzlefOS+s2TAWLweRSYE=";
            # };
            # doCheck = false;
            dontUsePytestCheck = true;
            pythonImportsCheck = [ ];
            meta = prevPkg.meta // {
              broken = false;
            };
          });
        };
      };
    };
}
