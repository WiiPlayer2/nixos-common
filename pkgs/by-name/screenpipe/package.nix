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
  version = "app-v2.5.57";
  src = fetchFromGitHub {
    owner = "screenpipe";
    repo = "screenpipe";
    rev = "app-v${finalAttrs.version}";
    hash = "sha256-wL8jwhEDCRnMsog6cDmf8uPu2Iaz0cZwQaVqYwwdeTs=";
  };

  cargoHash = "sha256-R/a54DM8X02cN0N/1SJSI/1BLw/XwYINX9BmVkGxDNI=";

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
