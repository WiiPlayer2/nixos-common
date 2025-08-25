{ lib, ... }:
with lib;
{
  mkGroupUseCaseOption =
    { description, options }:
    {
      enable = mkOption {
        inherit description;
        type = types.bool;
        default = false;
      };
    }
    // options;
  mkSubUseCaseOption = parent: description: {
    enable = mkOption {
      inherit description;
      type = types.bool;
      default = parent.enable;
    };
  };
  mkSubGroupUseCaseOption =
    parent:
    { description, options }:
    {
      enable = mkOption {
        inherit description;
        type = types.bool;
        default = parent.enable;
      };
    }
    // options;
}
