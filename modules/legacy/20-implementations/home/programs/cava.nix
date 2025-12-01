{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.programs.cava;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cavalier
    ];
    programs.cava = {
      enable = true;
      package = pkgs.cava.override {
        withSDL2 = true;
      };
      settings = {
        # output.method = "sdl";
        input = {
          method = "pulse";
        };
        color = mkIf (config.stylix.enable) (
          with config.lib.stylix.colors.withHashtag;
          {
            foreground = "'${base0B}'";
            background = "'${base00}'";
          }
        );
      };
    };
  };
}
