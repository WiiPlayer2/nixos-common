{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.media;
in
{
  options.my.useCase.media =
    let
      self = config.my.useCase.media;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Media";
      options = {
        music = mkSub "Music";
        video = mkSub "Video, Movies etc.";
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    (mkIf cfg.music.enable {
      my.programs = {
        vlc.enable = true;
        cava.enable = true;
        # feishin.enable = true; # electron is insecure
        finamp.enable = true;
        cyanrip.enable = true;
        # TODO: for now install both but in the future only one should suffice. As things stand clementine is the more feature rich application which re-started development but strawberry supports managment of cover art (even though it's just front cover apparently)
        clementine.enable = true;
        strawberry.enable = true;
      };
      my.services = {
        jellyfin-rpc.enable = true; # TODO: maybe this should be some kind of mixin
      };
    })
    (mkIf cfg.video.enable {
      my.programs = {
        vlc.enable = true;
        delfin.enable = true;
      };
      my.services = {
        jellyfin-rpc.enable = true; # TODO: maybe this should be some kind of mixin
      };
    })
  ];
}
