{ inputs, ... }:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.modules.default
    inputs.nix-monitor.homeManagerModules.default
  ];

  programs = {
    wezterm.enable = true; # currently managed outside
  };
}
