{
  fetchzip,
  stdenv,

  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,

  libglvnd,
  SDL2,
  libdrm,
  libxcrypt-legacy,
  lttng-ust_2_12,
  xkeyboard_config,
}:
let
  pname = "randovania";
  version = "10.9.0";
  src = fetchzip {
    url = "https://github.com/randovania/randovania/releases/download/v${version}/randovania-${version}-linux.tar.gz";
    hash = "sha256-0QriKkh8SJgNn1PWFcQgEH51wcjUADf72taU22eehCg=";
  };
in
stdenv.mkDerivation {
  inherit pname src version;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    libglvnd
    SDL2
    libdrm
    libxcrypt-legacy
    lttng-ust_2_12
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libtiff.so.5"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib}
    cp randovania $out/bin/randovania
    cp -r _internal/* $out/lib/
    ln -s $out/lib $out/bin/_internal

    wrapProgram $out/bin/randovania \
      --set QT_QPA_PLATFORM xcb

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "randovania-desktop";
      desktopName = "Randovania";
      categories = [
        "Game"
      ];
      exec = "randovania";
    })
  ];
}
