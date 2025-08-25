{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.programs.virt-manager;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      virt-manager

      # needs 'sudo chmod u+s $(which spice-client-glib-usb-acl-helper)' for now to work
      spice-gtk
    ];
  };
}
