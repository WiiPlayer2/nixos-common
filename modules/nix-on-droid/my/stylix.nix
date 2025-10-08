{ config, inputs, ... }:
let
  cfg = config.stylix;
in
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

    {
      stylix = {
        inherit (cfg)
          enable
          polarity
          base16Scheme
          image
          ;

        fonts = {
          inherit (cfg.fonts)
            sansSerif
            serif
            monospace
            ;
        };
      };
    }
  ];
}
