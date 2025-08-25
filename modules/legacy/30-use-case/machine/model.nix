{ lib, config, ... }:
with lib;
let
  mkIfElse =
    c: yes: no:
    mkMerge [
      (mkIf c yes)
      (mkIf (!c) no)
    ];
  cfg = config.my.machine;
in
{
  options.my.machine = {
    model = mkOption {
      description = "The model of the machine or null if custom or unknown. This will set some machine presets.";
      type =
        with types;
        nullOr (enum [
          "Framework Laptop 16"
        ]);
      default = null;
    };
  };

  config = mkIf (cfg.model != null) (
    mkIf (cfg.model == "Framework Laptop 16") {
      my.machine.devices = {
        displayBacklight.enable = true;
        battery.enable = true;
        fingerprint.enable = true;
      };
    }
  );
}
