# TODO: apparently the built python stuff is not included in the package atm. needs fixing
{
  lib,
  fetchFromGitHub,

  stdenv,
  buildNpmPackage,
  python313,
  electron,
  jq,
  breakpointHook,
}:
let
  pname = "openscribe";
  version = "172d8df_2026_03_02";
  src = fetchFromGitHub {
    owner = "travisgerrard";
    repo = pname;
    rev = "172d8df21e6b6281e95362d650e091603fed9c24";
    hash = "sha256-Rvjk2f+7kZQ+90bxMuZVJOJ6IkoacLj1tQsx8UndzEk=";
  };
  python = python313;
  pyinstaller = python.pkgs.pyinstaller;
in
buildNpmPackage {
  inherit pname version src;
  npmDepsHash = "sha256-nx5YY/gjN0iRWgpXvBcnRfqubLyKqNwrfnZacrgcP1w=";

  nativeBuildInputs = [
    pyinstaller
    jq
    breakpointHook
  ];

  buildInputs = [
    python
  ];

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  npmBuildScript = "build:python";

  postPatch = ''
    pyinstaller --name build_backend main.py
    sed -i 's/pyinstaller/pyinstaller -y/' package.json
  '';

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    jq '.*{build:{files:.build.files+["!**/*.so","!**/*.so.*"]}}' package.json > package.json.tmp
    mv package.json.tmp package.json

    # npmRebuild is needed because robotjs won't be built on darwin otherwise
    # asarUnpack makes sure to unwrap binaries so that nix can see the RPATH
    npm exec electron-builder -- \
        --dir \
        -c.npmRebuild=true \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/openscribe
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/openscribe

      makeWrapper ${lib.getExe electron} $out/bin/openscribe \
          --add-flags $out/share/openscribe/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --set-default ELECTRON_IS_DEV 0 \
          --inherit-argv0
    ''}

    runHook postInstall
  '';
}
