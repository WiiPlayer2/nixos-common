{
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "amnesia";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "cedws";
    repo = "amnesia";
    rev = "v${version}";
    hash = "sha256-vwrQYp6M90VdtDsz9rH/iffMQ2ZZKCc3QaKC62NtY4A=";
  };
in
buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-QgnkvL+GVRM5vnzgVk+C3PJW4onNt3p0yeaH+pdtfvA=";

  meta.mainProgram = "amnesia";
}
