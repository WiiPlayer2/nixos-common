{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.useCase.social;
in
{
  config = mkMerge [
    (mkIf cfg.chatting.telegram.enable {
      home.packages = with pkgs; [
        # tg
        # kotatogram-desktop
        # paper-plane
        # nchat
        # materialgram
        ayugram-desktop
      ];
      my.startup.ayugram-desktop.command = "ayugram-desktop -startintray";
    })
  ];
}
