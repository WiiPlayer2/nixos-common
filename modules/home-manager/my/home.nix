{ lib, pkgs, ... }:
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
    };

    packages = with pkgs; [
      tgpt
      file
      lshw
      pciutils
      usbutils
    ];
  };
}
