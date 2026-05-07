{ inputs, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  post-build-hook = pkgs.writeShellApplication {
    name = "post-build-hook";
    text = ''
      for _path in $OUT_PATHS; do
        ln -vs "$_path" "/var/lib/attic-push/$(basename "$_path")"
      done
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
