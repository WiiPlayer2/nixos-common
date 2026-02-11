{ pkgs, ... }:
{
  xdg.autostart = {
    enable = true;
    # readOnly = true; # when maestral is configured
    entries = [
      "${pkgs.variety}/share/applications/variety.desktop"
    ];
  };

  systemd.user.services."autostart-picom-block" = {
    Unit.Description = "block picom autostart";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "systemctl disable app-picom@autostart";
    };
  };
}
