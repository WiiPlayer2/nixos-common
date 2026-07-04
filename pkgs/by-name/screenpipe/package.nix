{
  lib,
  fetchFromGitHub,

  rustPlatform,
  pkg-config,
  clang,
  rustfmt,
  cmake,

  openssl_3,
  kdePackages,
  dbus,
  pipewire,
  libclang,
  onnxruntime,
  alsa-lib,
  libGL,
}:
with lib;
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "screenpipe";
  version = "2.5.91";
  src = fetchFromGitHub {
    owner = "screenpipe";
    repo = "screenpipe";
    rev = "app-v${finalAttrs.version}";
    hash = "sha256-MSxMZnQMcz+bvxOAgW9iiuH6m0y1UucXn5SPhqysnv0=";
  };

  cargoHash = "sha256-078NeMHcPndJx2U7w5oYEUupPA5XVINKkeOtehLPYEk=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    rustfmt
    cmake
  ];

  buildInputs = [
    openssl_3
    kdePackages.wayland
    dbus
    pipewire
    alsa-lib
    libGL
  ];

  env = {
    ORT_STRATEGY = "system";
    ORT_LIB_LOCATION = "${getLib onnxruntime}/lib";
  };
})
