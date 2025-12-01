{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.unified.hardware.wacom-tablet.enable = mkEnableOption "";

  config = mkIf config.unified.hardware.wacom-tablet.enable {
    environment.systemPackages = with pkgs; [
      xf86_input_wacom

      (writeShellApplication {
        name = "map-wacom-to-output";
        text = ''
          TABLET_NAME="Wacom Bamboo Pen Pen Pen (0)"
          OUTPUT="$1"

          ID="$(xinput list --id-only "$TABLET_NAME")"
          xinput map-to-output "$ID" "$OUTPUT"
        '';
      })
    ];
  };
}
