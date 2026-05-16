{
  fetchFromGitHub,

  rustPlatform,
}:
let
  pname = "mail-mcp";
  version = "0.4.7";
  src = fetchFromGitHub {
    owner = "tecnologicachile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0+leg/vF6XawPUQBQMguhNlAAJQIKeCx0XNaV3/ofAI=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoHash = "sha256-BYlEPxTicb55qI5q0WPObUpR1Hqe2apnrdjcfSqPBYk=";
}
