{
  fetchFromGitHub,
  python3,
  writeShellApplication,
  runCommand,
}:
let
  python = python3.withPackages (
    pypi: with pypi; [
      libvirt
    ]
  );
  src = fetchFromGitHub {
    owner = "nefelim4ag";
    repo = "libvirt-autoballoon";
    rev = "8ecd7faa95186f2595287101053e2c2d3d4efc29";
    hash = "sha256-jDLwjoPZ0PQStMWDcDDDOyIGZPSFHiVI+T0/0MfOTfI=";
  };
  pname = "libvirt-autoballoon";
  version = "0.3";
  script = writeShellApplication {
    name = pname;

    runtimeInputs = [
      python
    ];

    text = ''
      python ${src}/libvirt-autoballoon.py "$@"
    '';
  };
  package =
    runCommand "${pname}-${version}"
      {
        inherit pname version src;
        meta.mainProgram = pname;
      }
      ''
        mkdir -p $out/bin
        ln -s ${script}/bin/${pname} $out/bin/
      '';
in
package
