{
  lib,
  config,
  pkgs,
  hostConfig,
  ...
}:
with lib;
let
  autorandrOnDisplayChange = pkgs.writeShellApplication {
    name = "update-displays";
    text = ''
      /run/current-system/systemd/bin/systemctl --user --machine=${hostConfig.mainUser}@.host start --no-block autorandr.service || true
    '';
  };
in
{
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="drm", RUN+="${getExe autorandrOnDisplayChange}"
  '';
}
