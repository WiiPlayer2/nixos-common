{ fetchzip
, stdenv
, autoPatchelfHook
, makeDesktopItem
, symlinkJoin
, writeShellScriptBin
, libglvnd
, SDL2
, libdrm
, libxcrypt-legacy
, lttng-ust_2_12
,
}:
let
  pname = "randovania";
  version = "10.3.1";
  src = fetchzip {
    url = "https://github.com/randovania/randovania/releases/download/v${version}/randovania-${version}-linux.tar.gz";
    hash = "sha256-aa7Fnu2O3PRJxWQ6ScKOPQIL0QNiqrDRRFhm8GTa+LQ=";
  };
  binary-pkgs = stdenv.mkDerivation {
    inherit pname src version;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      libglvnd
      SDL2
      libdrm
      libxcrypt-legacy
      lttng-ust_2_12
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{bin,lib}
      cp randovania $out/bin/randovania
      cp -r _internal/* $out/lib/
      ln -s $out/lib $out/bin/_internal
      runHook postInstall
    '';
  };
  desktop-item = makeDesktopItem {
    name = "randovania-desktop";
    desktopName = "Randovania";
    categories = [
      "Game"
    ];
    exec = "${binary-pkgs}/bin/randovania";
  };
  wrapper = writeShellScriptBin "randovania-wrapper" ''
    exec ${binary-pkgs}/bin/randovania "$@"
  '';
  combined = symlinkJoin {
    name = binary-pkgs.name;
    paths = [
      wrapper
      desktop-item
    ];
    inherit pname version src;
  };
in
combined
