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
  version = "mcp-v0.18.2";
  src = fetchFromGitHub {
    owner = "screenpipe";
    repo = "screenpipe";
    rev = "app-v${finalAttrs.version}";
    hash = "sha256-lrbFGT9TJZYNB0IvvNnXKBJF75MuH7T51Zk+hV5toqs=";
  };

  cargoHash = "sha256-cePawblEhKob+luUA/9FWswozIXId/MukxrJcSdETT8=";

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
