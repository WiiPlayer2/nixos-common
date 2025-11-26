{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.office;
in
{
  options.my.useCase.office =
    let
      self = config.my.useCase.office;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Office use cases like checking e-mails";
      options = {
        email = mkSub "E-Mail";
        presentations = mkSub "Presentations";
      };
    };

  config = mkMerge [
    (mkIf cfg.email.enable {
      my.programs.thunderbird.enable = true;
    })
    (mkIf cfg.presentations.enable {
      my.programs.libreoffice.enable = true;
      my.programs.presenterm.enable = true;
      my.programs.slides.enable = true;
      my.programs.screenkey.enable = true;
      my.programs.bubbly.enable = true;
    })
  ];
}
