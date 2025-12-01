{ lib, pkgs, ... }:
with lib;
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      aliases = {
        yolo = "!git add -A && git commit -m \"$(${getExe pkgs.curl} -ks https://whatthecommit.com/index.txt)\"";
      };
      # https://git-scm.com/docs/git-config

      init = {
        defaultBranch = "main";
      };
      credential = {
        helper = "cache";
      };
      push = {
        autoSetupRemote = true;
      };
      submodule = {
        recurse = true;
      };
    };
  };
}
