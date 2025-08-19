{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    tmux
    lsof
  ];
}
