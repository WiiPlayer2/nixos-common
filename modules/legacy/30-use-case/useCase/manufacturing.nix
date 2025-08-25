{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.manufacturing;
in
{
  options.my.useCase.manufacturing =
    let
      self = config.my.useCase.manufacturing;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Manufacturing & Design";
      options = {
        _3dprint = mkSub "3D Printing";
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    (mkIf cfg._3dprint.enable {
      my.programs.freecad.enable = true;
      my.programs.prusa-slicer.enable = true;
    })
  ];
}
