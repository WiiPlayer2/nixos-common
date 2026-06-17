{ inputs, ... }:
{ lib, ... }:
with lib;
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.homeModules.default
    inputs.nix-monitor.homeManagerModules.default

    inputs.self.homeModules.programs-dank-material-shell
    # inputs.self.homeModules.cfg-librewolf
  ];

  programs = {
    wezterm.enable = true; # currently managed outside
    dank-material-shell.plugins.linuxWallpaperEngine.src = mkForce inputs.dms-wallpaperengine;
  };
}
