{ lib, config, ... }:
with lib;
{
  programs.dank-material-shell.session = {
    # Gamma Control
    nightModeEnabled = true;
    nightModeTemperature = 2500;
    nightModeHighTemperature = 6500;
    nightModeAutoEnabled = true;
    nightModeAutoMode = "location";
    nightModeUseIPLocation = true; # maybe hardcode or use provider
  };
}
