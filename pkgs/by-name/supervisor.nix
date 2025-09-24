{ stdenv
, lib
, pkgs
, fetchFromGitHub
, python3Packages
, nix-update-script
}:
pkgs.python3Packages.buildPythonApplication {
  pname = "supervisor";
  version = "4.3.0";
  src = fetchFromGitHub {
    owner = "Supervisor";
    repo = "supervisor";
    rev = "4.2.5";
    hash = "sha256-wfc/V7ZRmP3t99w06zpDNL0x4ocbZcLk+t6l3HDlgWk=";
  };
  doCheck = false;
  pyproject = true;
  build-system = with python3Packages; [ setuptools ];
  passthru.updateScript = nix-update-script { };
}
