{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.my.useCase.social;
in
{
  config = mkMerge [
    (mkIf cfg.chatting.telegram.enable {
      # TODO: tdlib-purple is currently broken
      # programs.pidgin = {
      #   enable = true;
      #   plugins = with pkgs.pidginPackages; [
      #     tdlib-purple
      #   ];
      # };
      home.packages = with pkgs; [
        # tg
        # kotatogram-desktop
        # paper-plane
        # nchat
        # materialgram
        unstable.ayugram-desktop
      ];
      my.startup.ayugram-desktop.command = "ayugram-desktop -startintray";
    })
  ];
}
