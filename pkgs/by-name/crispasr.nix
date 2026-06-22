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
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "CrispStrobe";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jPV0zJQVfMrY2c6IwcMQ3D0MvR7lOUd1fuK70KXum50=";
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
