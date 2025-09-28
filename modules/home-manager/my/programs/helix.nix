{ pkgs, ... }:
{
  programs.helix = {
    extraPackages = with pkgs; [
      nil
    ];
  };
}
