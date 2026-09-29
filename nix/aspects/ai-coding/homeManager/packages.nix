{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
    openspec
    junie-cli
  ];
}
