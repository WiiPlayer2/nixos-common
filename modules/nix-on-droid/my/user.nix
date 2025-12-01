{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  user.shell = getExe pkgs.zsh;
  environment.sessionVariables = {
    SHELL = getExe pkgs.zsh;
    XDG_RUNTIME_DIR = "/tmp/.run";
  };
  build = {
    activation.xdg-init = ''
      mkdir -p /tmp/.run
    '';
  };
}
