{
  fetchFromGitHub,
  buildGoModule,
}:
let
  pname = "trunkver";
  version = "1.1.3-20260821235137-g2e45f45-32538362362-1";
  src = fetchFromGitHub {
    owner = "crftd-tech";
    repo = "trunkver";
    rev = "${version}";
    hash = "sha256-cU2jZWEYOs8AvxVfOKw9TcTJqnJhx2/cwj5z5or5S9A=";
  };
in
buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-ZD1ALyVulVlbohnjjVGGgL7bm7C4lszzle3058Ry4S8=";

  meta.mainProgram = "trunkver";
}
