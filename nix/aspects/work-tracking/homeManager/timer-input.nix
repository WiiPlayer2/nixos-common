{ lib, pkgs, ... }:
with lib;
let
  timerInputScript = pkgs.writeShellApplication {
    name = "work-tracking-input";
    runtimeInputs = with pkgs; [
      dialogbox
    ];
    text = ''
      exec ${./_timer-input.sh}
    '';
  };
in
{
  systemd.user = {
    timers.work-tracking = {
      Unit = {
        Description = "Work tracking input timer";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
      Timer = {
        # https://systemd.guru/
        OnCalendar = "hourly";
      };
    };
    services.work-tracking = {
      Unit = {
        Description = "Work tracking input";
      };
      Service = {
        ExecStart = getExe timerInputScript;
      };
    };
  };
}
