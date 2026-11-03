{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
let
  src = fetchFromGitHub {
    owner = "vldsvrk";
    repo = "henro";
    rev = "a402c0b5ce57153065231959da7cd96dbf1a35ca";
    hash = "sha256-o3Mvpt9Z7tNfhAfKWN/utZu27Ca/bD0fiaIbQ7SHqVA=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "henro";
  version = "0-unstable-2026-04-29";
  inherit src;

  # Upstream uses pnpm; vendor an equivalent npm lockfile for the npm builder
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-AW8LatGd8jDzlhQs5AP6iYYSZz9lnlUDXoU9UkBo8Ws=";

  # Static site, no installable node package
  installPhase = ''
    mkdir -p $out/share
    cp -r dist $out/share/henro
  '';

  meta = {
    description = "Brainstorming canvas that expands your ideas with AI";
    homepage = "https://henro.space";
    sourceProvenance = with lib.sourceTypes; [
      downloaded
      copiedRecursively
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
})
