{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.programs.git;
in
{
  programs.git = {
    lfs.enable = true;
    aliases = {
      yolo = "!git add -A && git commit -m \"$(${getExe pkgs.curl} -ks https://whatthecommit.com/index.txt)\"";
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      credential = {
        helper = "cache";
      };
      push = {
        autoSetupRemote = true;
      };
    };
    difftastic = {
      enable = true;
      background = "dark";
    };
  };
}
