{
  systemd.services.suspend-lock = {
    description = "Lock the screen when suspending";
    before = [ "sleep.target" ];
    wantedBy = [ "sleep.target" ];
    script = "loginctl lock-sessions";
  };
}
