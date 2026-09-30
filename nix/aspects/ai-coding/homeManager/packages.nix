{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    openspec
    junie-cli
    acpx
    hydra-acp
    hydra-acp-browser
    hydra-acp-notifier
  ];
}
