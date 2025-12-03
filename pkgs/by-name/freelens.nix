{
  stdenv,
  fetchFromGitHub,

  nodejs,
  pnpm,
  jq,
  yq,
  moreutils,
  corepack,
  tinyxxd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freelens";
  version = "1.6.2";
  src = fetchFromGitHub {
    owner = "freelensapp";
    repo = "freelens";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bpPMKxFulOiROH/sjYThIvjPnVkR3H+m+iPBK6LPhN4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    jq
    yq
    moreutils
    corepack
    tinyxxd
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-M4OuddeH6X3wX4WWiyR+j7+ds2p259I9+qdyWchZfTA=";
  };

  npmDepsHash = "";

  env = {
    DEBUG = "corepack";
    # COREPACK_ENABLE_NETWORK = "0";
  };

  # see https://github.com/NixOS/nixpkgs/blob/ec3eddc130085d35e7345bdc930a6bd73181edf7/pkgs/by-name/in/insulator2/package.nix#L41
  postPatch = ''
    # jq 'del(.packageManager)' package.json | sponge package.json
    # jq 'setpath(["packageManager"]; "pnpm@${pnpm.version}")' package.json | sponge package.json
    jq 'del(.scripts."build:resources:client")' freelens/package.json | sponge freelens/package.json
  '';

  buildPhase = ''
    runHook preBuild

    _pnpmVersion=$(jq -r '.devDependencies.pnpm' package.json)
    mkdir -p $HOME/.cache/node/corepack/v1/pnpm
    ln -s $(realpath ./node_modules/pnpm) $HOME/.cache/node/corepack/v1/pnpm/$_pnpmVersion
    _lockHash=$(yq -r ".packages.\"pnpm@$_pnpmVersion\".resolution.integrity" pnpm-lock.yaml)
    _corepackHash="sha512.$(echo "''${_lockHash:7}" | base64 --decode | xxd -p)"
    jq -n '{
        locator: {
            name: "pnpm",
            reference: $version,
        },
        bin: {
            pnpm: "./bin/pnpm.cjs",
            pnpx: "./bin/pnpx.cjs",
        },
        hash: $hash,
    }' --arg version $_pnpmVersion --arg hash $_corepackHash > node_modules/pnpm/.corepack

    corepack pnpm build

    runHook postBuild
  '';

  # installPhase = ''
  #   mkdir -p $out/{bin,lib}

  #   cp -r ./{packages,node_modules,docs,demo} $out/lib/
  #   ln -sf $out/lib/packages/slidev/bin/slidev.mjs $out/bin/slidev
  # '';
})
