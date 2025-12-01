# Currently broken because types-typed-ast was removed (dependency of mypy, which itself is a dependency of tsrc)
{
  stdenv,
  lib,
  fetchFromGitHub,
  python312,
  loadPyproject,
  poetry2nix,
}:
let
  pname = "tsrc";
  version = "v3.0.1";
  src = fetchFromGitHub {
    owner = "your-tools";
    repo = pname;
    rev = version;
    hash = "sha256-4O+KGdRHoa47vsOlq9YwMS9qn/Iz7yOM3s6wzdXTeeY=";
  };
  package = poetry2nix.mkPoetryApplication {
    python = python312;
    projectDir = src;
    preferWheels = true;
    overrides = poetry2nix.overrides.withDefaults (
      final: prev: {
        mkdocs-material = prev.mkdocs-material.overridePythonAttrs (old: {
          dontPatch = true;
        });
      }
    );
    meta.broken = true;
  };
in
lib.recursiveUpdate package {
  passthru.skipUpdate = true;
}
