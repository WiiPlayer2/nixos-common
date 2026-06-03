{ inputs, ... }:
{ lib, ... }:
with lib;
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.modules.default
    inputs.nix-monitor.homeManagerModules.default

    inputs.self.homeModules.programs-dank-material-shell
  ];

  programs = {
    wezterm.enable = true; # currently managed outside
    dank-material-shell.plugins.linuxWallpaperEngine.src = mkForce inputs.dms-wallpaperengine;
  };
}
