{ inputs, ... }:
{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };

  modelsLib = import ./_models_lib.nix { inherit lib; };
  toModelConfig =
    id:
    {
      quant,
      model,
      aliases,
      ...
    }:
    {
      name = id;
      value = {
        inherit aliases;
        inherit (model) repo;
        ${if quant != null then "quant" else null} = quant;
      };
    };
  modelConfigs = mapAttrs' toModelConfig modelsLib.modelVariants;
in
{
  imports = [
    inputs.self.nixosModules.service-llama-swap
  ];

  environment.systemPackages = [
    llama-cpp
  ]
  ++ (with pkgs; [
    python312Packages.huggingface-hub
  ]);

  services = {
    llama-swap = {
      enable = true;
      port = 8090;
      settings = {
        healthCheckTimeout = 5 * 60; # 5min
        globalTTL = 60 * 60; # 15min
        sendLoadingState = false;
        includeAliasesInList = true;
        models = {
          "qwen3.6-35b:UD-IQ1_M".aliases = [
            "coding"
            "rider-core"
          ];
          "qwen3.5-0.8b:DEFAULT".aliases = [
            "small"
            "rider-instant"
          ];
        };
        matrix = {
          vars = {
            "08b" = "qwen3.5-0.8b:DEFAULT"; # ~2GB
            "9b" = "qwen3.5-9b:DEFAULT"; # ~8GB
          };
          sets = {
            standard = "08b & 9b";
          };
        };
      };

      llama-server = {
        package = llama-cpp;
        defaults = {
          dynamicPort = false;
          additionalArgs = [
            "--fit"
            "on"
            "--fit-target"
            "512"
            "--port"
            "\${PORT}"
          ];
        };
        models = modelConfigs;
      };
    };
  };

  systemd.services.llama-swap = {
    restartIfChanged = false;
    stopIfChanged = false;
  };

  security.sudo.extraRules = [
    {
      groups = [ "gamemode" ];
      commands = [
        {
          command = "${getExe' pkgs.systemd "systemctl"} start llama-swap";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${getExe' pkgs.systemd "systemctl"} stop llama-swap";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${getExe' pkgs.systemd "systemctl"} restart llama-swap";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  programs.gamemode = mkIf (config.programs.gamemode ? startCommands) {
    startCommands = "/run/wrappers/bin/sudo ${getExe' pkgs.systemd "systemctl"} stop llama-swap";
    endCommands = "/run/wrappers/bin/sudo ${getExe' pkgs.systemd "systemctl"} start llama-swap";
  };
}
