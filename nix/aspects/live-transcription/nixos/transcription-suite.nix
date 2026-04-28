{ lib, pkgs, ... }:
with lib;
{
  environment.systemPackages = with pkgs; [
    transcription-suite-appimage
  ];

  virtualisation.oci-containers.containers = {

  };
}
