{ lib, config, ... }:
let
  inherit (lib)
    mkIf
    ;

  cfg = config.wayland.windowManager.niri;
  stylixCfg = config.stylix;
in
{
  wayland.windowManager.niri = mkIf (stylixCfg.enable && cfg.enable) (
    with config.lib.stylix.colors.withHashtag;
    let
      text = base05;
      urgent = base08;
      focused = base0D;
      unfocused = base03;

      background = base00;
      indicator = base0B;
    in
    {
      settings = {
        cursor = {
          xcursor-theme = stylixCfg.cursor.name;
          xcursor-size = stylixCfg.cursor.size;
        };

        layout = {
          border = {
            active-color = focused;
            inactive-color = unfocused;
            urgent-color = urgent;
          };

          focus-ring = {
            active-color = focused;
            inactive-color = unfocused;
            urgent-color = urgent;
          };
        };
      };
    }
  );
}
