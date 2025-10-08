{ inputs, ... }:
{
  imports = [
    ../../_shared/stylix.nix
  ];

  stylix = {
    overlays.enable = false;
    homeManagerIntegration.autoImport = false;
  };

  home-manager.sharedModules = [
    inputs.stylix.homeModules.stylix
  ];
}
