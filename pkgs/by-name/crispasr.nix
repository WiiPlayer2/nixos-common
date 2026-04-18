{
  lib,
  fetchFromGitHub,

  stdenv,
  breakpointHook,
  cmake,
  whisper-cpp,

  blas,
}:
with lib;
let
  pname = "CrispASR";
  version = "0.4.1";
  src = fetchFromGitHub {
    owner = "CrispStrobe";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8pJ5sge+kmsP2+eaCH4h7STx8BKyZxySd2BL3+03sdA=";
  };
in
# whisper-cpp.overrideAttrs {
#   inherit pname version src;
# }
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    # breakpointHook
    cmake
  ];

  buildInputs = [
    blas
    # backends
  ];

  patchPhase = ''
    sed -i '1i cmake_minimum_required(VERSION 4.1)' src/CMakeLists.txt
  '';

  # postConfigure = ''
  #   pushd src
  #   cmake
  # '';
}
