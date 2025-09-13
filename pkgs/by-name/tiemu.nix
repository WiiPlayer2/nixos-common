{ fetchzip
, stdenv
, symlinkJoin

, autoreconfHook
, pkg-config

, libtifiles2
, libticalcs2
, libticables2
, libticonv
, gtk2
, gtk3
, gnome2
, SDL
, xorg
, libsForQt5
, glib
, gnused
, texinfo
, ncurses
, flex
}:
let
  pname = "tiemu";
  version = "3.02";
  # version = "3.03";
  src = fetchzip {
    url = "https://master.dl.sourceforge.net/project/gtktiemu/tiemu-linux/TiEmu%203.02/tiemu-3.02.tar.bz2?viasf=1";
    hash = "sha256-i0n+wPVuG5xDYBoyW8MMEYeq4KTqAnR/26C/hgnGEK4=";
    # url = "https://master.dl.sourceforge.net/project/gtktiemu/tiemu-linux/TIEmu%203.03/tiemu-3.03-nogdb.tar.gz?viasf=1";
    # hash = "sha256-+FurVxJ1smWfwgmtei0GiDIse9EiNsZn4K82YOpZ0Jo=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    pkg-config
    # autoreconfHook
    # libsForQt5.qt5.wrapQtAppsHook
  ];

  buildInputs = [
    gnused
    libtifiles2
    libticalcs2
    libticables2
    libticonv
    gtk2
    gnome2.libglade
    SDL
    xorg.libXt.dev
    texinfo
    # libsForQt5.qt5.qtbase.dev
    ncurses
    flex
  ];

  # PKG_CONFIG = "${pkg-config}/bin/pkg-config";
  # PKG_CONFIG_PATH = "${libticables2}/lib/pkgconfig:${libticalcs2}/lib/pkgconfig";

  # TICABLES_LIBS = "-L${libticables2}/lib -lticables2";
  # TICABLES_CFLAGS = "-I${libticables2}/include/tilp2";

  # TICALCS_LIBS = "-L${libticalcs2}/lib -lticalcs2";
  # TICALCS_CFLAGS = "-I${libticalcs2}/include/tilp2";

  # TIFILES_LIBS = "-L${libtifiles2}/lib -ltifiles2";
  # TIFILES_CFLAGS = "-I${libtifiles2}/include/tilp2";

  # TICONV_LIBS = "-L${libticonv}/lib -lticonv";
  # TICONV_CFLAGS = "-I${libticonv}/include/tilp2";

  # GLIB_LIBS = "-L${glib}/lib -lglib-2.0";
  # GLIB_CFLAGS = "-I${glib.dev}/include/glib-2.0 -I${glib}/lib/glib-2.0/include";

  # GTK_LIBS = "-L${gtk2}/lib -lgtk-x11-2.0";
  # GTK_CFLAGS = "-I${gtk2.dev}/include/gtk-2.0";

  # GLADE_LIBS = "-L${gnome2.libglade}/lib -lglade-2.0";
  # GLADE_CFLAGS = "-I${gnome2.libglade.dev}/include/libglade-2.0";

  patchPhase = ''
    sed "s/s,'CC=\[^'\]\*',,g/s,'CC=[^']*',,g;s,'PKG_CONFIG=[^']*',,g/" -i ./configure
    # sed "s/main(){return(0);}/int main(){return(0);}/" -i ./src/gdb/configure
    sed "141,145d" -i ./src/core/uae/sysdeps.h
    sed "105,107d;197d" -i ./src/gui/device.c
    sed "s/GtkFunction/AtkFunction/" -i ./src/gui/calc/calc.c
    sed "s/GtkNotebookPage/GtkNotebookTab/" -i ./src/gui/debugger/dbg_mem.c
  '';

  configureFlags = [
    "--without-kde"
    "--x-includes=${xorg.libXt.dev}/include"
    "--x-libraries=${xorg.libXt}/lib"
    # "--disable-gdb"
    # "--with-qt-dir=${libsForQt5.qt5.qtbase.dev}"
    # "--with-qt-includes=${libsForQt5.qt5.qtbase.dev}/include"
    # "--with-qt-libraries=${libsForQt5.qt5.qtbase.dev}/lib"
  ];

  CFLAGS = [
    "-Wno-error=implicit-int"
  ];

  preBuild = ''
    NIX_CFLAGS_COMPILE="-Wno-error=implicit-int -Wno-error=format-security -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types -Wno-error=int-conversion $NIX_CFLAGS_COMPILE"

    pushd src/gdb/readline
    ./configure
    make
    popd
  '';

  buildFlags = [
    # "CFLAGS=\"-Wno-error=implicit-int\""
    "MAKEINFO=true"
  ];
}
