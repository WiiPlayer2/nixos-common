{
  fetchFromGitHub,

  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "junie-api";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "fabienfleureau";
    repo = finalAttrs.pname;
    rev = "c56c86a406ac0d6003458d2979ae81d3e73eeac5";
    hash = "sha256-PAAxdq1QsRIbVuPT3RHzvYa8sXONxladCWE0Kyq50KI=";
  };

  npmDepsHash = "sha256-2tq8eSjuwlTyJVOzCheRCTURJpGwCzDR2QADOBPtBPc=";
})
