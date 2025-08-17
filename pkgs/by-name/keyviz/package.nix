{ lib
, fetchFromGitHub
, flutter327
, xorg
,
}:
let
  inherit (lib)
    importJSON
    ;
in
flutter327.buildFlutterApplication rec {
  pname = "keyviz";
  version = "2.0.0a3";

  src = fetchFromGitHub {
    owner = "mulaRahul";
    repo = pname;
    rev = "v2.0.0a3";
    hash = "sha256-HRIO4kXxf4luYanCgGK0DUGYFaxo9Px/uQCqvjG3F58=";
  };

  buildInputs = [
    xorg.libX11
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXcursor
    xorg.libXi
  ];

  pubspecLock = importJSON ./pubspec.lock.json; # convert using cat pubspec.lock | nix run nixpkgs#yj

  gitHashes = {
    window_size = "sha256-71PqQzf+qY23hTJvcm0Oye8tng3Asr42E2vfF1nBmVA=";
  };

  meta.broken = true;
}
