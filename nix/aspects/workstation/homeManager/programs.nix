{ pkgs, ... }:
{
  home.packages = with pkgs; [
    showmethekey
    super-productivity
    junie-cli
  ];

  xdg.autostart.entries = [
    "${pkgs.super-productivity}/share/applications/superproductivity.desktop"
  ];
}
