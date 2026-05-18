{ inputs, ... }:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  programs.dank-material-shell = {
    enable = true;
    enableAudioWavelength = false; # For now due to cava conflict
  };
}
