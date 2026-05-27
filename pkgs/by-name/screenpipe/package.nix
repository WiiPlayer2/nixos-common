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
  version = "2.4.285";
  src = fetchFromGitHub {
    owner = "screenpipe";
    repo = "screenpipe";
    rev = "app-v${finalAttrs.version}";
    hash = "sha256-si/qKgz/wtM0nSPbAOm5DrD5dYgbOs47dhtyLMgca0o=";
  };

  cargoHash = "sha256-x52dtPPZZzRyAo4wr5WycJdlMRiqZEVK2Oj3o/emYv0=";

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
