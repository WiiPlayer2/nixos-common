{ pkgs, ... }:
{
  home.packages = with pkgs; [
    showmethekey
    super-productivity
    aria2
    ariang
    jdk21
    paperweight-appimage
  ];

  xdg.autostart.entries = [
    "${pkgs.super-productivity}/share/applications/superproductivity.desktop"
  ];
}
