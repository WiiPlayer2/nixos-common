{ pkgs, ... }:
{
  home.packages = with pkgs; [
    showmethekey
    super-productivity
    aria2
    ariang
  ];

  xdg.autostart.entries = [
    "${pkgs.super-productivity}/share/applications/superproductivity.desktop"
  ];
}
