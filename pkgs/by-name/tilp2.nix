{ fetchzip
, stdenv

, autoreconfHook

, intltool
, pkg-config
, libtifiles2
, libticalcs2
, libticables2
, libticonv
, gtk2

, glib
}:
let
  pname = "tilp2";
  version = "1.18";
  src = fetchzip {
    url = "https://www.ticalc.org/pub/unix/tilp.tar.gz";
    hash = "sha256-Z9/iPoqzoiG2sOy3r0RAm1Y/W+LmszAoAHRfsZbqoTU=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  postUnpack = ''
    sed -i -e '/AC_PATH_KDE/d' source/configure.ac
    sed -i \
        -e 's/@[^@]*\(KDE\|QT\|KIO\)[^@]*@//g' \
        -e 's/@X_LDFLAGS@//g' \
        source/src/Makefile.am
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    intltool
    libtifiles2
    libticalcs2
    libticables2
    libticonv
    gtk2
  ];

  buildInputs = [ glib ];
}
