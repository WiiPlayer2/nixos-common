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
  version = "0.5.6";
  src = fetchFromGitHub {
    owner = "CrispStrobe";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pxv0yOOIqMORqpP8MAY8FpRI0u5K4hmRfQXWuHQo/K0=";
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
