{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.creative;
in
{
  options.my.useCase.creative =
    let
      self = config.my.useCase.creative;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Creative work";
      options = {
        graphics = mkSub "Photo/Image Editing & Drawing";
        _3d = mkSub "3D Modelling & Editing";
        sound = mkSub "Sound/Music Editing & Production";
        video = mkSub "Video Editing & Production";
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    (mkIf cfg.graphics.enable {
      my.programs = {
        krita.enable = true;
        gimp.enable = true;
        inkscape.enable = true;
        aseprite.enable = true;
      };
    })
    (mkIf cfg._3d.enable {
      my.programs = {
        blender.enable = true;
      };
    })
    (mkIf cfg.video.enable {
      my.programs = {
        shotcut.enable = true;
      };
    })
    (mkIf cfg.sound.enable {
      my.programs = {
        audacity.enable = true;
        lmms.enable = true;
      };
    })
  ];
}
