{ lib, inputs, ... }:
with lib;

{
  name,
  systems ? [ "x86_64-linux" ],
  modules ? [ ],
}:

let
  mkImage =
    system:
    let
      nixosConfig = inputs.nixpkgs.lib.nixosSystem {
        modules = modules ++ [
          inputs.self.nixosModules.container-image
          {
            nixpkgs.hostPlatform = system;
            containerImage.name = name;
          }
        ];
      };
    in
    nixosConfig.config.system.build.image;

  images = genAttrs systems mkImage;

  publishScript =
    system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    pkgs.writeShellApplication {
      name = "publish-${name}";
      runtimeInputs = with pkgs; [
        podman
        gawk
      ];
      text = ''
        set -x
        REGISTRY="$1"
        NAME="${name}"
        REPOSITORY="$REGISTRY/$NAME"
        TAG="$2"

        function publish-arch() {
          NIX_ARCH="$1"
          IMAGE_PATH="$2"
          FULL_NAME="$REPOSITORY:$TAG-$NIX_ARCH"
          IMAGE_TAG="$(podman load < "$IMAGE_PATH" | awk '{print $NF}')"

          podman tag "$IMAGE_TAG" "$FULL_NAME"
          podman push "$FULL_NAME"
        }

        ${concatLines (
          attrValues (mapAttrs (system: image: "publish-arch \"${system}\" \"${images.${system}}\"") images)
        )}

        FULL_NAME="$REPOSITORY:$TAG"
        podman manifest rm "$FULL_NAME" 2> /dev/null || true
        podman manifest create --amend \
          "$FULL_NAME" \
          ${concatLines (map (system: "  \"$FULL_NAME-${system}\" \\") systems)}

        podman manifest push "$FULL_NAME"
      '';
    };
in
{
  inherit name images publishScript;
}
