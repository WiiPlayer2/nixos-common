{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.my.components.graphical;
in
{
  config =
    with lib;
    mkIf cfg.enable {
      xdg.systemDirs.data = [
        "/var/lib/flatpak/exports/share"
        "/home/admin/.local/share/flatpak/exports/share"
      ];

      services.flatpak = {
        enable = true;
        update = {
          onActivation = true;
        };
        packages = lib.mkOptionDefault [
          "com.github.tchx84.Flatseal"
        ];
      };
    };
}
