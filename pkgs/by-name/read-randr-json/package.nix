{
  stdenv,
  fetchFromGitHub,
  xorg,
}:

let
  pname = "read-randr-json";
  version = "main";
  src = fetchFromGitHub {
    owner = "zignageX";
    repo = pname;
    rev = "main";
    hash = "sha256-IhL6SxmO0zg7a+xVOFH973+ibXYb0+M1F6WVAP8+sas=";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  buildInputs = [
    xorg.libxcb.dev
  ];

  makeFlags = [ "prefix=$(out)" ];

  patches = [
    ./checkout.patch
  ];

  passthru.skipUpdate = true;
}
