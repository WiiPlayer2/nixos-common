{
  lib,
  fetchFromGitHub,
  fetchurl,

  buildNpmPackage,
  stdenv,
}:
let
  inherit (lib)
    mapAttrs
    ;

  version = "0.28.31";
  archs = {
    "x86_64-linux" = "linux-x64";
  };
  arch = archs.${stdenv.hostPlatform.system};
  urls = {
    base = "https://github.com/backnotprop/plannotator/releases/download/v${version}/plannotator-${arch}";
    paste = "https://github.com/backnotprop/plannotator/releases/download/v${version}/plannotator-paste-${arch}";
  };
  hashesPerArch = {
    "x86_64-linux" = {
      base = "sha256-Xk+XLrn3LrnYWI+ZMXNcN9kKHu2AW4VY4xd7Uo5egUo=";
      paste = "sha256-AAMw+sO0eN5qf0R1W9dGs2pEt3RyJltS5gD+qgnefqw=";
    };
  };
  hashes = hashesPerArch.${stdenv.hostPlatform.system};
  binaries = mapAttrs (
    n: v:
    fetchurl {
      url = v;
      hash = hashes.${n};
    }
  ) urls;
in
stdenv.mkDerivation {
  pname = "plannotator";
  inherit version;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${binaries.base} $out/bin/plannotator
    cp ${binaries.paste} $out/bin/plannotator-paste
    chmod +x $out/bin/*
  '';

  dontStrip = true;
}
# buildNpmPackage (finalAttrs: {
#   pname = "plannotator";
#   version = "0.28.31";
#   src = fetchFromGitHub {
#     owner = "backnotprop";
#     repo = "plannotator";
#     rev = "v${finalAttrs.version}";
#     hash = "sha256-iCPaPlddFewj9JL5CEs48BW4D6p+j3RXyNbMc16+r6Q=";
#   };
#   npmDepsHash = "";
# })
