{
  pkgs,
  lib,
  fetchurl,
  makeDesktopItem,
  binutils,
  gnutar,
  xdg-utils,
  patchelf,
}:

let
  pname = "whiteboard";
  version = "0.5.1";
  src = fetchurl {
    url = "https://github.com/devdotfast/whiteboard/releases/download/v${version}/whiteboard_${version}-1_amd64.deb";
    hash = "sha256-zasnQKXfjW+Ux0IA+fV+w5yDtoO9bu4pbiAogIes/ao=";
  };

  icon = pkgs.runCommand "${pname}-icon" { inherit src; } ''
    mkdir -p $out /tmp/wb-extract
    ar x $src
    tar -xf data.tar.xz -C /tmp/wb-extract
    cp /tmp/wb-extract/usr/share/icons/hicolor/512x512/apps/whiteboard.png $out/
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Whiteboard";
    exec = "${pname}-desktop %F";
    icon = icon;
    categories = [ "Development" ];
  };

  # Compute the library path from all runtime dependencies
  libPath = lib.makeLibraryPath (
    with pkgs;
    [
      nspr
      libX11
      libxcb
      libXext
      libXfixes
      libXi
      libXcursor
      libXrender
      libgbm
      expat
      libxkbcommon
      libsecret
      libnotify
      gtk3
      nss
      libxkbfile
      libxcomposite
      libxdamage
      libxrandr
      libxtst
      cups
      libXScrnSaver
      at-spi2-core
      libdrm
      libva
      alsa-lib
      dbus
      glib
      libepoxy
      mesa
      vulkan-loader
      pango
      cairo
      at-spi2-core
      gtk3
      gdk-pixbuf
      hicolor-icon-theme
    ]
  );

in
pkgs.runCommand "${pname}-${version}"
  {
    inherit src;
    nativeBuildInputs = [
      binutils
      gnutar
      xdg-utils
      patchelf
    ];
    buildInputs = with pkgs; [
      nspr
      libX11
      libxcb
      libXext
      libXfixes
      libXi
      libXcursor
      libXrender
      libgbm
      expat
      libxkbcommon
      libsecret
      libnotify
      gtk3
      nss
      libxkbfile
      libxcomposite
      libxdamage
      libxrandr
      libxtst
      cups
      libXScrnSaver
      at-spi2-core
      libdrm
      libva
      alsa-lib
      dbus
      glib
      libepoxy
      mesa
      vulkan-loader
      pango
      cairo
    ];
    passthru = { inherit desktopItem icon; };

    meta = {
      description = "Open-source canvas for thoughtful software design";
      homepage = "https://whiteboard.dev.fast/";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      sourceProvenance = with lib.sourceTypes; [ downloaded ];
    };
  }
  ''
    mkdir -p $out/bin $out/lib $out/share/applications $out/share/icons/hicolor/512x512/apps

    # Extract manually: dpkg-deb -x fails in the sandbox applying the
    # setuid mode of chrome-sandbox, so unpack with ar/tar instead.
    ar x $src
    tar -xf data.tar.xz -C $out

    mv $out/usr/bin/whiteboard $out/bin/${pname}
    mv $out/usr/bin/whiteboard-desktop $out/bin/${pname}-desktop
    mv $out/usr/share/whiteboard $out/lib/${pname}

    install -Dm644 $out/usr/share/applications/dev-fast-review.desktop \
      $out/share/applications/${pname}.desktop
    cp $out/usr/share/icons/hicolor/512x512/apps/whiteboard.png \
      $out/share/icons/hicolor/512x512/apps/

    # Point the shell wrappers and desktop entry at the nix store paths
    sed -i "s|/usr/share/whiteboard|$out/lib/${pname}|g" \
      $out/bin/${pname} $out/bin/${pname}-desktop
    sed -i "s|Exec=/usr/bin/whiteboard-desktop|Exec=${pname}-desktop|g" \
      $out/share/applications/${pname}.desktop

    rm -rf $out/usr

    # The setuid bit on chrome-sandbox cannot be set inside the sandbox;
    # without it Electron falls back to its less-secure sandbox mode.
    chmod 4755 $out/lib/${pname}/chrome-sandbox || true

    # Patch all ELF binaries in the app dir to include runtime libs
    for bin in $out/lib/${pname}/*; do
      if file "$bin" | grep -q "ELF"; then
        patchelf --set-rpath "\$ORIGIN:${libPath}" "$bin"
      fi
    done
  ''
