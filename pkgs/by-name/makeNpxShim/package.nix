{
  lib,
  stdenv,
  makeWrapper,
  nodejs,
}:
let
  inherit (lib)
    getExe'
    ;
in
{
  pname,
  package ? pname,
  version ? "latest",
  npx ? getExe' nodejs "npx",
  exe ? pname,
}:
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;
  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${npx} $out/bin/${finalAttrs.pname} \
      --add-flags "-y --package=${package}@${version} ${exe}"
  '';
})
