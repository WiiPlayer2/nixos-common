{
  lib,
  stdenv,
  makeWrapper,

  nix,
  jq,
  python312,
}:
stdenv.mkDerivation {
  pname = "llm-tools";
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
        --prefix PATH : ${
          lib.makeBinPath [
            nix
            jq
            python312.pkgs.huggingface-hub
          ]
        }
    done
  '';
}
