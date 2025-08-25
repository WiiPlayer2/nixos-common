{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.android-tools;
in
{
  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      android-udev-rules
    ];
  };
}
