{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.pmbootstrap;
  pmbootstrapVersion = "3.9.0";
  # TODO: Move to pkgs and override on demand. nixpkgs does contain an up-to-date version
  # pmbootstrapSrc = pkgs.fetchFromGitLab {
  #     owner = "postmarketos";
  #     repo = "pmbootstrap";
  #     rev = version;
  #     hash = "sha256-ijXyX+VJqiS0z5IOXGjeL2SGZ/4ledhnq/Zr1ZLW/Io=";
  #     domain = "gitlab.postmarketos.org";
  #   };
  pmbootstrapSrc = pkgs.fetchgit {
    url = "https://gitlab.postmarketos.org/postmarketOS/pmbootstrap.git";
    rev = "refs/tags/${pmbootstrapVersion}";
    hash = "sha256-eDngGcHNfxphshNyIoRC4NZA4KUBHSJjshsGaNp8Uw0=";
  };
  pmbootstrapCli = pkgs.pmbootstrap.overridePythonAttrs rec {
    version = pmbootstrapVersion;
    src = pmbootstrapSrc;
    doCheck = false;
  };
  pmbootstrapHelpers = pkgs.writeShellScriptBin "pmbootstrap-envkernel" ''
    # Run with "source $(pmbootstrap-envkernel)"
    echo "${pmbootstrapSrc}/helpers/envkernel.sh"
  '';
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pmbootstrapCli
      pmbootstrapHelpers
    ];
  };
}
