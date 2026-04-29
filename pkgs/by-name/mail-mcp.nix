{
  fetchFromGitHub,

  rustPlatform,
}:
let
  pname = "mail-mcp";
  version = "0.4.5";
  src = fetchFromGitHub {
    owner = "tecnologicachile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6E1Rbx1qL3+l02UyY4D2SML/VyDA3uoD67B/AIBmt2g=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoHash = "sha256-9lluoujA9/P/r22O86r/QKLr4pymjNafwHprQcZKp+o=";
}
