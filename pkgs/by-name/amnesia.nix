{
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "amnesia";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "cedws";
    repo = "amnesia";
    rev = "v${version}";
    hash = "sha256-V2IYWXbd3qtYuqBdDYIBvMHnwOj493Q0nQkGYi4jCdA=";
  };
in
buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-QgnkvL+GVRM5vnzgVk+C3PJW4onNt3p0yeaH+pdtfvA=";

  meta.mainProgram = "amnesia";
}
