{
  fetchFromGitHub,

  rustPlatform,
}:
let
  pname = "mail-mcp";
  version = "0.4.2";
  src = fetchFromGitHub {
    owner = "tecnologicachile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0At4NEcwg9kY+GDoYzwjVSeF2IzVhsyxg7ig5XdqLSo=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoHash = "sha256-TM/6d74BfP1lXfkjLhmoSFM523CgjaGr1DCtnylV4OA=";
}
