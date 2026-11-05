{
  stdenv,
  lib,
  fetchFromGitHub,
  replaceVars,
  nix-update-script,
  copyDesktopItems,
  makeDesktopItem,

  zig_0_16,
  makeWrapper,

  python3Packages,
  python3,
  gdb,
  qt6,
  gtk3,
  gobject-introspection,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      capstone
      keyboard
      keystone-engine
      msgpack
      pexpect
      pygdbmi
      pygobject3
      pyqt6
    ]
  );

  gdb' = gdb.override {
    python3 = pythonEnv;
  };

  # LD_LIBRARY_PATH libraries
  LDPath = lib.makeLibraryPath [
    (lib.getLib stdenv.cc.cc)
    gtk3
    gdb'
  ];

  # GI_TYPELIB_PATH libraries
  GIPath = lib.makeSearchPath "lib/girepository-1.0" [
    gtk3
    gobject-introspection
  ];
in

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pince";
  version = "0.10.2";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "korcankaraokcu";
    repo = "PINCE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tx1rQdbQo/xCwr25Io54o1tOBdwvWFK79EPOvErn5I8=";
    fetchSubmodules = true;
  };

  patches = [
    (replaceVars ./set-gdb-path.patch {
      gdb_exe_path = lib.getExe gdb';
    })
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    zig_0_16
    gobject-introspection
    qt6.qttools
    qt6.wrapQtAppsHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    pythonEnv
    gdb'
    gobject-introspection
    qt6.qtbase
    qt6.qtwayland
    gtk3
  ];

  dontUseCmakeConfigure = true;

  buildPhase = ''
    runHook preBuild

    export ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-cache
    export ZIG_LOCAL_CACHE_DIR=$TMPDIR/zig-cache

    # libmemscan
    pushd libmemscan
    zig build -Doptimize=ReleaseFast
    install -Dm555 zig-out/lib/libmemscan.so -t ../libpince/libmemscan/
    install -Dm444 memscan.py -t ../libpince/libmemscan/
    popd

    # mono_collector
    pushd mono_collector
    zig build -Doptimize=ReleaseFast -Dtarget=x86_64-linux-gnu
    install -Dm555 zig-out/lib/libmono_collector.so ../libpince/libmono_collector/mono_collector_x64.so

    zig build -Doptimize=ReleaseFast -Dtarget=x86-linux-gnu
    install -Dm555 zig-out/lib/libmono_collector.so ../libpince/libmono_collector/mono_collector_x86.so

    zig build -Doptimize=ReleaseFast -Dtarget=x86_64-windows-gnu
    install -Dm555 zig-out/bin/mono_collector.dll ../libpince/libmono_collector/mono_collector_wine_x64.dll

    zig build -Doptimize=ReleaseFast -Dtarget=x86-windows-gnu
    install -Dm555 zig-out/bin/mono_collector.dll ../libpince/libmono_collector/mono_collector_wine_x86.dll
    popd

    # Translations
    lrelease i18n/ts/*
    mkdir -p i18n/qm
    mv i18n/ts/*.qm i18n/qm/

    runHook postBuild
  '';

  makeWrapperArgs = [
    "--chdir"
    "${placeholder "out"}/lib/pince"
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    LDPath
    "--prefix"
    "GI_TYPELIB_PATH"
    ":"
    GIPath
    "--set"
    "PYTHONPATH"
    "${placeholder "out"}/lib/pince"
    "--set"
    "PYTHONDONTWRITEBYTECODE"
    "1"
    "--add-flags"
    "${placeholder "out"}/lib/pince/PINCE.py"
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ pythonEnv ])
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pince/
    cp -r GUI i18n libpince media tr AUTHORS COPYING COPYING.CC-BY PINCE.py THANKS $out/lib/pince/

    mkdir -p $out/bin
    cat > $out/bin/pince << EOF
    #!${stdenv.shell}
    if [ "\$(id -u)" -eq 0 ]; then
      exec $out/lib/pince/PINCE.py "\$@"
    elif which pkexec; then
      exec pkexec env DISPLAY=\$DISPLAY WAYLAND_DISPLAY=\$WAYLAND_DISPLAY XDG_SESSION_TYPE=\$XDG_SESSION_TYPE XDG_RUNTIME_DIR=\$XDG_RUNTIME_DIR $out/lib/pince/PINCE.py "\$@"
    elif which sudo; then
      exec sudo -E $out/lib/pince/PINCE.py "\$@"
    else
      echo "Must be run as root."
      exit 1
    fi
    EOF
    chmod +x $out/bin/pince

    mkdir -p $out/share/icons/hicolor/512x512/apps
    ln -s $out/lib/pince/media/logo/ozgurozbek/pince_appimage.png $out/share/icons/hicolor/512x512/apps/pince.png

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/lib/pince" "$out ''${pythonPath[*]}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "pince";
      desktopName = "Pince";
      icon = "pince";
      categories = [
        "Game"
      ];
      exec = "pince";
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Reverse engineering tool for games (Linux alternative to Cheat Engine)";
    homepage = "https://github.com/korcankaraokcu/PINCE";
    mainProgram = "pince";
    license = with lib.licenses; [
      gpl3Plus
      cc-by-30
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yuannan ];
  };
})
