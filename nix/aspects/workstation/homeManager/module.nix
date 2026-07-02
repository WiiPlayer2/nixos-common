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

  services = {
    kanshi.enable = true; # managed per host
  };

  # No because of too many shared configs as of now
  # xsession.windowManager.i3.enable = warn "Forcing i3 to be disabled, but should be cleaned up properly" (mkForce false);
}
