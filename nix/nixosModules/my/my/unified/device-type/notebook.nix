{ config, lib, ... }:
with lib;
{
  options.unified.device-type.notebook.enable = mkEnableOption "";

  config = mkIf config.unified.device-type.notebook.enable {
    services = {
      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          CPU_DRIVER_OPMODE_ON_AC = "active";
          CPU_DRIVER_OPMODE_ON_BAT = "guided";

          #   #Optional helps save long term battery health
          #   START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
          #   STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };
    };

    home-manager.sharedModules = [
      {
        unified.device-type.notebook.enable = true;
      }
    ];
  };
}
