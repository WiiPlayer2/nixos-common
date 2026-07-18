{
  fetchFromGitHub,

  rustPlatform,
}:
let
  pname = "mail-mcp";
  version = "0.4.9";
  src = fetchFromGitHub {
    owner = "tecnologicachile";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-w5m3694/jutpmthGHSw3JdhEScT3+s+J9gcVhoMfKNg=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoHash = "sha256-rlP22bDp1UkVgTT8rkdHikVfF5P+Wy0KncHzGAdXkR4=";
}
