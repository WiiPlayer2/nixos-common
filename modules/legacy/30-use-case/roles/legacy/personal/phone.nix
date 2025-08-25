{ pkgs
, lib
, config
, ...
}:
let
  cfg = config.my.roles.legacy.personal.phone;
in
{
  options.my.roles.legacy.personal.phone = with lib; {
    enable = mkEnableOption "Whether to enable the phone personal role";
  };

  config =
    with lib;
    mkIf cfg.enable {
      my.components = {
        graphical = {
          enable = false;
          windowManager.i3 = {
            enable = true;
            profile = "phone";
            blocks = {
              moveButtons.enable = true;
            };
          };
          development.misc = true;
        };
        terminal = {
          enable = true;
          development.misc = true;
        };
      };
      my.personalization.wallpaper = ../../../../assets/wallpaper/portrait/sakuya_screen_wipe.jpg;
    };
}
