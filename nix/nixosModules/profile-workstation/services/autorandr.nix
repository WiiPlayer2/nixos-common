{ hostConfig, ... }:
{
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="drm", RUN+="/run/current-system/systemd/bin/systemctl --user --machine=${hostConfig.mainUser}@.host start --no-block autorandr.service"
  '';
}
