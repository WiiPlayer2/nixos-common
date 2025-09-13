{ rustPlatform
, fetchFromGitHub
, nix-update-script
}:
let
  pname = "p2p-clipboard";
  version = "0-unstable-2025-01-31";
  package = rustPlatform.buildRustPackage {
    inherit pname version;
    src = fetchFromGitHub {
      owner = "WiiPlayer2";
      repo = pname;
      rev = "adc5de7c0ef52c5869f9a7f72ccb4bc9ddc5b898";
      hash = "sha256-HjRSNgXb/gZehFKO36m4HED2I8rvvtes8UPQ+Q2RLBY=";
    };
    cargoHash = "sha256-Vwrnpbaem6QnHK/BT+jZ2qeO8m/hrS3IvxT0j0q98WQ=";
    passthru.updateScript = nix-update-script {
      extraArgs = [ "--version=branch=update-to-rust-1.80.0" ];
    };
  };
in
package
