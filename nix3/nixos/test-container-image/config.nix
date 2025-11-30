{ lib, config, pkgs }:
with lib;
{
  nixpkgs.hostPlatform = "x86_64-linux";
  containerImage = {
    # script = ''
    #   ${getExe pkgs.hello}
    # '';
    systemdService = "snapserver";
  };
  services.snapserver = {
    enable = true;
    streams.default.location = "pipe:///tmp/snapfifo?name=default";
  };
  systemd.services.snapserver.serviceConfig = {
    ExecStart = mkForce "${config.services.snapserver.package}/bin/snapserver";
    Type = mkForce "oneshot";
  };
}
