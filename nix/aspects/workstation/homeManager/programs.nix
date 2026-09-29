{ pkgs, ... }:
{
  home.packages = with pkgs; [
    showmethekey
    super-productivity
  ];

  xdg.autostart.entries = [
    "${pkgs.super-productivity}/share/applications/superproductivity.desktop"
  ];
}
