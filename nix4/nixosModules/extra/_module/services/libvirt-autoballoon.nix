{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.libvirt-autoballoon;
  settingsFile = pkgs.writers.writeJSON "autoballoon.json" cfg.settings;
in
{
  options.services.libvirt-autoballoon = {
    enable = mkEnableOption "Whether libvirt-autoballoon service should be enabled.";
    package = mkOption {
      type = types.package;
      default = pkgs.libvirt-autoballoon;
    };
    settings = mkOption {
      type = types.anything;
      default = {
        vms = { };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings ? "vms";
        message = "libvirt-autoballoon configuration needs toplevel \"vms\" key.";
      }
    ];

    environment.systemPackages = [
      cfg.package
    ];

    systemd.services.libvirt-autoballoon = {
      after = [ "local-fs.target" ];
      script = "${getExe cfg.package} start";
      serviceConfig = {
        Nice = 19;
        SuccessExitStatus = 143;
        OOMScoreAdjust = -999;
        Restart = "always";
        RestartSec = "1s";
        CPUAccounting = true;
        MemoryHigh = "16M";
        MemoryMax = "64M";
        ProtectSystem = true;
        ProtectHome = true;
        PrivateTmp = "yes";
      };
      wantedBy = [ "local-fs.target" ];

      restartTriggers = [
        settingsFile
      ];
    };

    environment.etc."libvirt/autoballoon.json".source = settingsFile;
  };
}
