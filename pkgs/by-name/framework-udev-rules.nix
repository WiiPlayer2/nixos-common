{ stdenv
, fetchFromGitHub
,
}:
let
  pname = "framework-udev-rules";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "inputmodule-rs";
    rev = "v${version}";
    hash = "sha256-5sqTkaGqmKDDH7byDZ84rzB3FTu9AKsWxA6EIvUrLCU=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  # Only copies udevs rules
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp release/50-framework-inputmodule.rules $out/lib/udev/rules.d/
  '';
}
