{ lib, config, pkgs, ... }:
with lib;
let
  colored = cmd: "${cmd} --color=auto";
in
{
  home = {
    shellAliases = {
      ls = colored "ls";
      dir = colored "dir";
      vdir = colored "vdir";

      grep = colored "grep";
      fgrep = colored "fgrep";
      egrep = colored "egrep";

      ll = "ls -alhF";
      la = "ls -A";
      l = "ls -CF";
    };

    sessionVariables = {
      "DiffEngine_ToolOrder" = "VisualStudioCode";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/${config.services.ssh-agent.socket}";
    };

    packages = with pkgs; [
      tgpt
      file
      lshw
      pciutils
      usbutils
      mob
    ];
  };
}
