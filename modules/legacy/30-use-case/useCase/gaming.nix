{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.gaming;
in
{
  options.my.useCase.gaming =
    let
      self = config.my.useCase.gaming;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Gaming";
      options = {
        steam = mkSub "Steam";
        vr = mkSub "VR";
        cloud-gaming = mkSub "Cloud Gaming (Host)";
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    # TODO: This should be in a sub group/option
    (mkIf cfg.enable {
      my.programs = {
        atlauncher.enable = true;
        bottles.enable = true;
        lutris.enable = true;
        obs-studio.enable = true;
        poptracker.enable = true;
        protontricks.enable = true;
        retroarch.enable = true;
        ryujinx.enable = true;
        wine.enable = true;
        gamemode.enable = true;
      };
    })
    (mkIf cfg.steam.enable {
      my.programs.steam.enable = true;
    })
    (mkIf cfg.vr.enable {
      # https://wiki.nixos.org/wiki/VR
      # my.programs.envision.enable = true; # Does not work currently
      my.services.monado.enable = true;
      my.programs.wlx-overlay-s.enable = true;
    })
  ];
}
