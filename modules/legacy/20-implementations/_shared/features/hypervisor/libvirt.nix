{
  lib,
  config,
  pkgs,
  flake-inputs,
  ...
}:
with lib;
let
  NixVirt = flake-inputs.NixVirt;
  cfg = config.my.features.hypervisor;
in
{
  config = mkIf cfg.enable {
    virtualisation = {
      libvirt = {
        enable = true;
        swtpm.enable = true;
        verbose = true;

        connections."qemu:///system" = {
          networks =
            if cfg.networks.extra == null then
              null
            else
              let
                networkCfgs = attrsToList cfg.networks.extra;
                enabledNetworkCfgs = filter ({ value, ... }: value.enable) networkCfgs;
                mkNetwork =
                  { name, value }:
                  {
                    definition = value.definition;
                    active = true;
                  };
                networksFromCfg = map mkNetwork enabledNetworkCfgs;
              in
              networksFromCfg;

          domains =
            if cfg.domains.extra == null then
              null
            else
              let
                domainCfgs = attrsToList cfg.domains.extra;
                enabledDomainCfgs = filter ({ value, ... }: value.enable) domainCfgs;
                mkDomain =
                  { name, value }:
                  {
                    inherit (value) definition active restart;
                  };
                domainsFromCfg = map mkDomain enabledDomainCfgs;
              in
              domainsFromCfg;
        };
      };
    };
  };
}
