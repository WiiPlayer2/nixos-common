{ inputs, ... }:
{
  stylix = {
    overlays.enable = false;
    homeManagerIntegration.autoImport = false;
  };

  home-manager.sharedModules = [
    inputs.stylix.homeModules.stylix
  ];
}
