{ pkgs, ... }:
{
  xdg.autostart = {
    enable = true;
    # readOnly = true; # when maestral is configured
    entries = [
      "${pkgs.variety}/share/applications/variety.desktop"
    ];
  };
}
