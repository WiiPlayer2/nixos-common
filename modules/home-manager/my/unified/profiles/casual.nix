{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.unified.profiles.casual.enable = mkEnableOption "";

  config = mkIf config.unified.profiles.casual.enable {
    programs = {
      keepassxc = {
        enable = true;
      };
    };

    services.ssh-agent.enable = true;

    home.packages = with pkgs; [
      maestral
      maestral-gui
      whatsie
      music-assistant-companion-appimage
    ];

    my.startup = {
      # Wait 5 seconds for system theme to be correctly set
      keepassxc.command = "sleep 5 && keepassxc-startup && keepassxc-watch";
      maestral.command = "${pkgs.maestral-gui}/bin/maestral_qt";
      whatsie.command = "${lib.getExe pkgs.whatsie}";
    };
  };
}
