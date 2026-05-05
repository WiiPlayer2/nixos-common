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
    pkgs.llama-proxy
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
        globalTTL = 15 * 60; # 15min
        sendLoadingState = true;
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
          # "gemma4-26b".aliases = [ "rider-core" ];
        };
        # TODO: Migrate to matrix and either use fix context sizes or additional configurations
        # groups.persistent = {
        #   persistent = true;
        #   swap = false;
        #   exclusive = false;
        #   members = [
        #     "qwen3.5-0.8b"
        #   ];
        # };
      };

      llama-server = {
        package = llama-cpp;
        defaults = {
          # contextSize = mkDefault (64 * 1024);
          commandPrefix = "${getExe pkgs.llama-proxy} --port \${PORT} --";
          dynamicPort = false;
          additionalArgs = [
            "--fit"
            "on"
            "--fit-target"
            "512"
          ];
        };
        models = modelConfigs;
      };
    };
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
