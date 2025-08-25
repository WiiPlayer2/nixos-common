{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.remoteAccess;
in
{
  options.my.useCase.remoteAccess =
    let
      self = config.my.useCase.remoteAccess;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Remote Access";
      options = {
        ssh = mkSub "SSH";
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    (mkIf cfg.ssh.enable {
      my.services.ssh.enable = true;
    })
  ];
}
