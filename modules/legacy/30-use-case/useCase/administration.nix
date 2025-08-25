{ lib, config, ... }@args:
with lib;
with import ./_lib.nix args;
let
  cfg = config.my.useCase.administration;
in
{
  options.my.useCase.administration =
    let
      self = config.my.useCase.administration;
      mkSub = mkSubUseCaseOption self;
      mkSubGroup = mkSubGroupUseCaseOption self;
    in
    mkGroupUseCaseOption {
      description = "Administration of servers, services and devices";
      options = {
        kubernetes = mkSub "Kubernetes";
        databases = mkSub "Databases";
      };
    };

  # TODO: move everything one level up to my.*
  config = mkMerge [
    (mkIf cfg.kubernetes.enable {
      my.programs = {
        kubecolor.enable = true;
        kubernetes-helm.enable = true;
        helmfile.enable = true;
        fluxcd.enable = true;
      };
    })
    (mkIf cfg.databases.enable {
      my.programs = {
        # datagrip.enable = true;
      };
    })
  ];
}
