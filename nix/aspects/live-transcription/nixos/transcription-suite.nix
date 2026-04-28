{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  # TODO: appimage currently needs a containers/policy.json
  environment.systemPackages = with pkgs; [
    transcription-suite-appimage
  ];

  warnings =
    optional (config.virtualisation.podman.enable && config.virtualisation.podman.dockerCompat)
      ''
        Podman's docker compatibilty option might not work correctly with Transcription Suite.
      '';

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = mkDefault true;
    };
    # oci-containers.containers = {

    # };
  };
}
