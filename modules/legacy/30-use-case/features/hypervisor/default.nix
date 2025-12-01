{
  lib,
  config,
  flake-inputs,
  pkgs,
  ...
}@args:
with lib;
let
  NixVirt = flake-inputs.NixVirt;
  templates = {
    domain = NixVirt.lib.domain.templates;
  };
  cfg = config.my.features.hypervisor;
  isGraphical = config.my.features.graphical.enable;
  _lib =
    let
      autounattend = import ./autounattend.nix args;
    in
    autounattend;
  presetArgs = {
    inherit
      NixVirt
      _lib
      templates
      pkgs
      cfg
      ;
    inherit (flake-inputs.self) images;
  };
  importPreset = path: {
    enable = true;
    definition = import path presetArgs;
  };
in
{
  options.my.features.hypervisor = {
    enable = mkEnableOption "QEMU / KVM / Libvirt";
    domains = {
      presets = {
        windows = {
          enable = mkEnableOption "Windows VM";
          installMode = mkEnableOption "Whether the VM should contain configuration for installation";
          config = {
            cpus = mkOption {
              description = "The amount of available cores. Must not include CPU threads but the actual core count.";
              type = types.int;
              default = 2;
            };
            memory = mkOption {
              description = "Memory in GiB";
              type = types.int;
              default = 4;
            };
          };
        };
        pentest = {
          enable = mkEnableOption "Pentest VM";
          config = {
            qemu = mkOption {
              description = "The qemu to use";
              type = types.nullOr types.path;
              default = null;
            };
            cpus = mkOption {
              description = "The amount of available cores. Must not include CPU threads but the actual core count.";
              type = types.int;
              default = 2;
            };
            memory = mkOption {
              description = "Memory in GiB";
              type = types.int;
              default = 4;
            };
          };
        };
      };
      extra = mkOption {
        type = types.nullOr (
          types.attrsOf (
            types.submodule (
              { config, ... }:
              {
                options = {
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                  };

                  active = mkOption {
                    type = with types; nullOr bool;
                    default = null;
                  };

                  restart = mkOption {
                    type = with types; nullOr bool;
                    default = null;
                  };

                  definition = mkOption {
                    description = "The path to the definition file.";
                    type = types.path;
                  };
                };
              }
            )
          )
        );
        default = null;
      };
    };
    networks = {
      presets = {
        defaultBridge = {
          enable = mkOption {
            description = "Default bridge network";
            type = types.bool;
            default = true;
          };
        };
      };
      extra = mkOption {
        type = types.nullOr (
          types.attrsOf (
            types.submodule (
              { config, ... }:
              {
                options = {
                  enable = mkOption {
                    type = types.bool;
                    default = true;
                  };

                  definition = mkOption {
                    description = "The path to the definition file.";
                    type = types.path;
                  };
                };
              }
            )
          )
        );
        default = null;
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable && isGraphical) {
      my.programs.virt-manager.enable = true;
    })
    (mkIf (cfg.enable && cfg.domains.presets.windows.enable) {
      my.features.hypervisor.domains.extra.windows = importPreset ./presets/domains/windows;
    })
    (mkIf (cfg.enable && cfg.domains.presets.pentest.enable) {
      my.features.hypervisor.domains.extra.pentest = importPreset ./presets/domains/pentest;
    })
    (mkIf (cfg.enable && cfg.networks.presets.defaultBridge.enable) {
      my.features.hypervisor.networks.extra.defaultBridge = importPreset ./presets/networks/defaultBridge;
    })
  ];
}
