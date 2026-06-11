{
  services = {
    accounts-daemon.enable = true;
    cinnamon.apps.enable = true;
    fprintd.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    printing.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    displayManager.defaultSession = "sway-uwsm";
  };
}
