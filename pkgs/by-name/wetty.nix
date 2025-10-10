{ lib
, fetchFromGitHub
, stdenv
, writeShellApplication
, runCommand
, nodejs
, pnpm
, dart-sass
}:
let
  pname = "wetty";
  version = "main";
  src = fetchFromGitHub {
    owner = "butlerx";
    repo = pname;
    rev = "20923e1bd02d64ab31c34ec77c2617d195b23318";
    # tag = version;
    # hash = "sha256-baCcmfZRS7PBDlA7hM3nFVSE1/RNJ6Qz8awwikCZmEg=";
    hash = "sha256-GnSYJ/DuTsq2WVbQqWj8slN40YHSHdu1/YqXFfbNEUk=";
  };
  libData = stdenv.mkDerivation (final: {
    inherit pname version src;

    # --- only on main branch ---
    nativeBuildInputs = [
      nodejs
      nodejs.pkgs.node-gyp-build
      pnpm.configHook
    ];

    NIX_NODEJS_BUILDNPMPACKAGE = "1";

    pnpmDeps = pnpm.fetchDeps {
      inherit (final) pname version src;
      fetcherVersion = 2;
      hash = "sha256-2aQALC5EDjaaJCwG5j8D81+VEFNl54iL8e/KLXhJCg0=";
    };

    buildPhase = ''
      runHook preBuild

      export NIX_NODEJS_BUILDNPMPACKAGE=1

      # force the sass npm dependency to use our own sass binary instead of the bundled one
      substituteInPlace node_modules/.pnpm/sass-embedded@1.77.5/node_modules/sass-embedded/dist/lib/src/compiler-path.js \
        --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
      pnpm build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      export NIX_NODEJS_BUILDNPMPACKAGE=1

      mkdir -p $out
      cp package.json $out/
      cp -R build $out/
      pnpm install --frozen-lockfile --offline --production ---ignore-scripts
      cp -R node_modules $out/

      runHook postInstall
    '';
  });
  launchScript = writeShellApplication {
    name = "wetty";
    runtimeInputs = [
      nodejs
    ];
    text = ''
      NODE_ENV=production exec node ${libData}
    '';
  };
  pkg = runCommand libData.name
    {
      passthru = {
        data = libData;
      };
    } ''
    mkdir -p $out/lib
    ln -sf ${launchScript}/bin $out/bin
    ln -sf ${libData} $out/lib/wetty
  '';
in
pkg
