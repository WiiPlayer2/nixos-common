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
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "CrispStrobe";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qnCPVLh8qZKclNVcUdtKMHb4HgNq+H39eJ3NJ2PwrsI=";
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
