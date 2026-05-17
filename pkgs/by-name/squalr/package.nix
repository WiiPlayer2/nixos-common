{
  fetchFromGitHub,

  rustPlatform,
  pkg-config,

  openssl,
}:
let
  pname = "Squalr";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "Squalr";
    repo = "Squalr";
    rev = "v${version}";
    hash = "sha256-ujhh4QWcXUduT/dqHbWOIxW6MC7x3R6FgOAYTghyBBc=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  # for some reason these inputs do not work; they're replaced by the env variables for now
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];
  # PKG_CONFIG = "${pkg-config}/bin/pkg-config";
  # PKG_CONFIG_PATH = "${systemd.dev}/lib/pkgconfig";

  env = {
    RUSTC_BOOTSTRAP = 1;
  };

  cargoBuildFlags = [
    "-p"
    "squalr-tui"
    "-p"
    "squalr-cli"
    "-p"
    "squalr"
  ];

  # buildNoDefaultFeatures = true;
  # buildFeatures = [
  #   "squalr-cli"
  #   "squalr-tui"
  #   "squalr"
  # ];

  cargoHash = "sha256-te5zf+/byq1pIgDyzlF6atEQAAhtpvJYE5LTtjHuxp0=";

  # meta.mainProgram = "ledmatrix_widgets";
}
