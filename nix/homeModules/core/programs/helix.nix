{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      nil
    ];

    languages.language-server.omnisharp.timeout = 60;
  };
}
