{
  fetchFromGitHub,

  rustPlatform,
}:
let
  pname = "mail-mcp";
  version = "0.4.8";
  src = fetchFromGitHub {
    owner = "tecnologicachile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AeMs2VoOyR78ec0T1q+0g/TdnNOh9RRN6Pyx8km075s=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoHash = "sha256-RDiIbrFYrHim/daWX/7ajiYjfYdysb3Av7rkIMb0yo8=";
}
