{
  lib,
  stdenv,
  makeWrapper,

  rage,
  openssh,
}:
let
  path = lib.makeBinPath [
    rage
    openssh
  ];
in
stdenv.mkDerivation {
  pname = "nixos-config-tools";
  version = "0.1";
  src = ./src;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./* $out/bin/

    for script in $out/bin/* ; do
      wrapProgram $script \
        --prefix PATH : ${path}
    done
  '';
}
