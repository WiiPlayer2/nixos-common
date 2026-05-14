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
      link_path () {
        _path="$1"
        ln -vs "$_path" "/var/lib/attic-push/$(basename "$_path")" 2>&1
      }

      link_path_retry () {
        MAX_RETRY=3
        _path="$1"
        for ((i=1; i <= MAX_RETRY; i++)); do
          if link_path "$_path"; then
            break
          fi

          sleep "''${i}s"
        done

        echo "Failed to link $_path after $MAX_RETRY tries."
      }

      for _path in $OUT_PATHS; do
        link_path_retry "$_path"
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
