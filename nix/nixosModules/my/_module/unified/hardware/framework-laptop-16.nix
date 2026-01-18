{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
{
  options.unified.hardware.framework-laptop-16.enable = mkEnableOption "";

  config = mkIf config.unified.hardware.framework-laptop-16.enable {
    services = {
      udev = {
        packages = with pkgs; [
          framework-udev-rules
        ];
        extraRules = ''
          # Framework Laptop 16 keyboard & macropad
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="FRAKDKEN0100000000", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        '';
      };

      tlp.settings = {
        # tlp-stat -p
        CPU_SCALING_MIN_FREQ_ON_AC = 0;
        CPU_SCALING_MAX_FREQ_ON_AC = 5263000; # kHz
        CPU_SCALING_MIN_FREQ_ON_BAT = 0;
        CPU_SCALING_MAX_FREQ_ON_BAT = 2000000;
      };

      ledmatrix-widgets.enable = true;
    };

    environment.systemPackages = with pkgs; [
      (writeShellApplication {
        name = "configure-framework-input";
        runtimeInputs = [
          # ungoogled-chromium
          chromium
        ];
        text = ''
          chromium https://keyboard.frame.work/
        '';
      })
    ];
  };
}
