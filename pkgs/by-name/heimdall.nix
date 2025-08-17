# https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/tools/misc/heimdall/default.nix#L49
{ lib
, stdenv
, fetchgit
, cmake
, zlib
, libusb1
, enableGUI ? false
, qtbase ? null
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "heimdall${lib.optionalString enableGUI "-gui"}";
  version = "2.2.2";

  # src = fetchFromGitHub {
  #   owner  = "Benjamin-Dobell";
  #   repo   = "Heimdall";
  #   rev    = "v${version}";
  #   sha256 = "1ygn4snvcmi98rgldgxf5hwm7zzi1zcsihfvm6awf9s6mpcjzbqz";
  # };
  src = fetchgit {
    url = "https://git.sr.ht/~grimler/Heimdall";
    rev = "v${version}";
    hash = "sha256-ga2hAZhsKosEG//qXEf+1vhJYtsHwyq6QvMlZaSFIgQ=";
  };

  buildInputs = [
    zlib
    libusb1
  ] ++ lib.optional enableGUI qtbase;
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DDISABLE_FRONTEND=${if enableGUI then "OFF" else "ON"}"
  ];

  preConfigure =
    ''
      # Give ownership of the Galaxy S USB device to the logged in user.
      substituteInPlace heimdall/60-heimdall.rules --replace 'MODE="0666"' 'TAG+="uaccess"'
    ''
    + lib.optionalString stdenv.isDarwin ''
      substituteInPlace libpit/CMakeLists.txt --replace "-std=gnu++11" ""
    '';

  installPhase =
    lib.optionalString (stdenv.isDarwin && enableGUI) ''
      mkdir -p $out/Applications
      mv bin/heimdall-frontend.app $out/Applications/heimdall-frontend.app
      wrapQtApp $out/Applications/heimdall-frontend.app/Contents/MacOS/heimdall-frontend
    ''
    + ''
      mkdir -p $out/{bin,share/doc/heimdall,lib/udev/rules.d}
      install -m755 -t $out/bin                bin/*
      install -m644 -t $out/lib/udev/rules.d   ../heimdall/60-heimdall.rules
      # install -m644 ../Linux/README   $out/share/doc/heimdall/README.linux
      # install -m644 ../OSX/README.txt $out/share/doc/heimdall/README.osx
    '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://git.sr.ht/~grimler/Heimdall";
    description = "A cross-platform tool suite to flash firmware onto Samsung Galaxy S devices";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
    mainProgram = "heimdall";
  };
}
