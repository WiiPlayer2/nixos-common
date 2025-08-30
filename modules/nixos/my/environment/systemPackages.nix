{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    btop
    tmux
    lsof
    nix-output-monitor
    iotop-c
  ];
}
