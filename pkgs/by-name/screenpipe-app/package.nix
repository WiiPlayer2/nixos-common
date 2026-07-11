{
  lib,
  fetchFromGitHub,

  stdenvNoCC,
  writableTmpDirAsHomeHook,
  rustPlatform,
  pkg-config,
  cargo-tauri,
  nodejs,
  bun,
  npmHooks,
  fetchNpmDeps,
  # bun2nix,
  opencode,
  breakpointHook,
}:
with lib;
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "screenpipe-app";
  version = "2.5.105";
  src = fetchFromGitHub {
    owner = "screenpipe";
    repo = "screenpipe";
    rev = "app-v${finalAttrs.version}";
    hash = "sha256-KbZsCWYdMNLjxX+A92HOPHhZEMvBK9N+vG0ny9DcwUc=";
  };

  cargoHash = "sha256-ATdd6znMs2071UfU31trXjvgCPiTo+qgsYHhgtJEals=";
  cargoRoot = "apps/screenpipe-app-tauri/src-tauri";

  # npmDeps = fetchNpmDeps {
  #   name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
  #   inherit (finalAttrs) src;
  #   hash = "";
  # };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
      breakpointHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      pushd ./apps/screenpipe-app-tauri
      bun install \
        --cpu="*" \
        --force \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*" \
        --production

      bun --bun ${opencode.src}/nix/scripts/canonicalize-node-modules.ts
      bun --bun ${opencode.src}/nix/scripts/normalize-bun-binaries.ts
      popd

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    # NOTE: Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = "sha256-ATdd6znMs2071UfU31trXjvgCPiTo+qgsYHhgtJEals=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  # bunDeps = bun2nix.fetchBunDeps {
  #   bunNix = ./bun.nix;
  # };

  nativeBuildInputs = [
    # Pull in our main hook
    cargo-tauri.hook

    # Setup npm
    # bun2nix.hook
    bun
    nodejs

    # Make sure we can find our libraries
    pkg-config
  ];

  preBuild = ''
    cp -a ${finalAttrs.node_modules}/{node_modules,packages} .
    chmod -R u+w node_modules packages
    # patchShebangs node_modules packages/desktop/node_modules
  '';
})
