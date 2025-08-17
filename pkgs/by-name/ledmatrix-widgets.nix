{ fetchFromGitHub
, rustPlatform
, pkg-config
, systemd
}:
let
  pname = "ledmatrix-widgets";
  version = "0.2";
  src = fetchFromGitHub {
    owner = "superrm11";
    repo = "ledmatrix_widgets";
    rev = "v${version}";
    hash = "sha256-Fm6Al++dHD9FsCyl6BDklZ2H9VnXAeKCMeBh2bvG+24=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  # for some reason these inputs do not work; they're replaced by the env variables for now
  # nativeBuildinputs = [
  #   pkg-config
  # ];
  # buildInputs = [
  #   systemd.dev
  # ];
  PKG_CONFIG = "${pkg-config}/bin/pkg-config";
  PKG_CONFIG_PATH = "${systemd.dev}/lib/pkgconfig";

  cargoHash = "sha256-9w0XevNZWtejMS42d4FbPUKpDYcu5WjnsarFdanWngI=";

  meta.mainProgram = "ledmatrix_widgets";
}
