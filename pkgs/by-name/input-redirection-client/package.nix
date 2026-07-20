{
  stdenv,
  fetchFromGitHub,

  libsForQt5,
  # wrapQtAppsHook,

  # qtbase,
  # qtgamepad,
  # qttools,
}:
with libsForQt5;
stdenv.mkDerivation {
  pname = "input-redirection-client";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "TuxSH";
    repo = "InputRedirectionClient-Qt";
    rev = "019cb9f127df12b51ecdf43fe93e27ef321a7d2b";
    hash = "sha256-K9eBPkQCmGSQeEcBIKA8aHXTqlxn7c0qM6ItHXAy3Kg=";
  };

  buildInputs = [
    qtbase
    qtgamepad
  ];
  nativeBuildInputs = [
    qttools
    wrapQtAppsHook
  ];

  configurePhase = ''
    qmake ./InputRedirectionClient-Qt.pro
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./InputRedirectionClient-Qt $out/bin/
  '';

  meta.mainProgram = "InputRedirectionClient-Qt";
}
