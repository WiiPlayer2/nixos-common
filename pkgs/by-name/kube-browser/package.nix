{
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "kube-browser";
  version = "1.0.14";
  src = fetchFromGitHub {
    owner = "brunosvianna";
    repo = "kube-browser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vv3IDPmRWvkWceJ49iEXEssJ40LXdT+iXhTOk7/M4qQ=";
  };
  vendorHash = "sha256-XuK66ixa18zO4qf4jQ79MGyMKQURyUR67kRpoYVO60A=";
})
