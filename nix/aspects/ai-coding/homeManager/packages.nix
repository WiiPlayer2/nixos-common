{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    junie-cli
    acpx
    hydra-acp
    hydra-acp-browser
    hydra-acp-notifier
  ];
}
