{
  lib,
  fetchurl,
  mkDotnetBinary,
  stdenv,
  autoPatchelfHook,
  makeWrapper,

  libgcc,
  icu,
  openssl,
}:
# ref: https://github.com/Homebrew/homebrew-cask/blob/ee45aa717ecf1e89b9291b3bef6fff2f7622ae99/Casks/d/devtunnel.rb
let
  pname = "devtunnel";
  version = "1.0.1886+37d3b95bd3";
  src = fetchurl {
    url = "https://tunnelsassetsprod.blob.core.windows.net/cli/${version}/linux-x64-devtunnel";
    hash = "sha256-p1WPD7AWfMy7naJlQ9Pmouvv9j+JNLc6ek4VQdAm1RA=";
  };
in
mkDotnetBinary {
  inherit pname version src;
}
# stdenv.mkDerivation {
#   inherit pname version;

#   src = binary;
#   dontUnpack = true;
#   sourceRoot = ".";

#   nativeBuildInputs = [
#     autoPatchelfHook
#     makeWrapper
#   ];

#   buildInputs = [
#     libgcc.lib
#   ];

#   runtimeDependencies = [
#     icu
#     # openssl
#   ];

#   installPhase = ''
#     mkdir -p $out/bin/
#     cp ${binary} $out/bin/devtunnel
#     chmod +x $out/bin/devtunnel

#     wrapProgram $out/bin/devtunnel \
#       --suffix LD_LIBRARY_PATH : ${
#         lib.makeBinPath [
#           openssl
#         ]
#       }
#   '';

#   dontStrip = true;
# }
