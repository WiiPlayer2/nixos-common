{
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "amnesia";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "cedws";
    repo = "amnesia";
    rev = "v${version}";
    hash = "sha256-hcyfEcmmuel2crCDMUdJ5QKVhwgEnDPvS6Ra2f2NTKA=";
  };
in
buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-vHKDp+zUHEuOB2aYQWHEgTrtEQSzr9kCUZ0FUkQlRTc=";

  meta.mainProgram = "amnesia";
}
