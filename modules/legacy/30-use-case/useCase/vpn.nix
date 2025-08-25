{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.vpn;
in
{
  options.my.useCase.vpn =
    let
      self = config.my.useCase.vpn;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "VPN";
      options = {
        mullvad = mkSub "Mullvad";
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    (mkIf cfg.mullvad.enable {
      my.services.mullvad.enable = true;
    })
  ];
}
