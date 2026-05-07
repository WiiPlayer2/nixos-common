{ inputs, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  # TODO: Use daemon to queue push jobs
  post-build-hook = pkgs.writeShellApplication {
    name = "attic-push";
    runtimeInputs = with pkgs; [
      attic-client
    ];
    text = ''
      # shellcheck disable=SC2086
      attic push default $OUT_PATHS || true
    '';
  };
in
{
  imports = [
    inputs.self.nixosModules.read-only-cache
  ];

  age.secrets.nix-attic-config.path = "/root/.config/attic/config.toml";

  nix.settings = {
    # Use 'NIX_CONFIG="post-build-hook = " nix build ...' if something doesn't work correctly
    post-build-hook = getExe post-build-hook;
  };
}
