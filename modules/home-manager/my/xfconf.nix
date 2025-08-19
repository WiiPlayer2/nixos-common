{ lib, config, ... }:
with lib;
let
  cfgOs = config.my.os;
in
{
  # TODO: Currently checks if it's a graphical environment by checking if vscode is enabled
  xfconf.settings = mkIf (cfgOs.type != "nix-on-droid" && config.programs.vscode.enable) {
    pointers = {
      "PIXA385400_093A0274_Touchpad/ReverseScrolling" = true;
    };
    xsettings = {
      "Net/ThemeName" = "Mint-Y-Dark-Aqua";
      "Net/IconThemeName" = "Mint-Y-Aqua";
      "Gtk/CursorThemeName" = "Bibata-Modern-Classic";
    };
    xfce4-keyboard-shortcuts = {
      "commands/custom/<Super>r" = null;
      "commands/custom/<Super>e" = null;
      "commands/custom/<Alt>F1" = null;
      "commands/custom/<Primary><Alt>t" = null;
    };
  };
}
