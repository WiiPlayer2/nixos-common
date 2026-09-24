{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mapAttrs'
    getExe'
    mkIf
    escapeShellArgs
    ;

  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };

  modelsLib = import ../_models_lib.nix { inherit lib; };
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

  mkLlama =
    {
      model,
      name ? model,
      context,
      slots ? 2,
      extraArgs ? [ ],
    }:
    {
      inherit name;
      cmd = "${getExe' llama-cpp "llama-server"} ${
        escapeShellArgs (
          [
            "--no-warmup"
            "--parallel"
            (toString slots)
            "--gpu-layers"
            "auto"
            "--jinja"
            "--cache-type-k"
            "q4_0"
            "--cache-type-v"
            "q4_0"
            "-hf"
            model
            "--ctx-size"
            (toString (context * slots))
            "--port"
            "\${PORT}"
          ]
          ++ extraArgs
        )
      }";
      capabilities = {
        inherit context;
        "in" = [
          "text"
          "image"
        ];
        out = [ "text" ];
        tools = true;
      };
    };

  mkQwen3_5_08b =
    quant: nameSuffix:
    mkLlama {
      model = "unsloth/Qwen3.5-0.8B-GGUF:${quant}";
      name = "Qwen3.5 0.8B${nameSuffix}";
      context = 262144;
      slots = 4;
      extraArgs = [
        "--temperature"
        "0.6"
        "--top-p"
        "0.95"
        "--top-k"
        "20"
        "--min-p"
        "0.0"
        "--presence-penalty"
        "0.0"
        "--repeat-penalty"
        "1.0"
        "--image-min-tokens"
        "1024"
      ];
    };

  mkQwen3_6_35b_a3b =
    quant: nameSuffix:
    mkLlama {
      model = "unsloth/Qwen3.6-35B-A3B-GGUF:${quant}";
      name = "Qwen3.6 35B A3B${nameSuffix}";
      context = 262144;
      slots = 1;
      extraArgs = [
        "--temperature"
        "0.6"
        "--top-p"
        "0.95"
        "--top-k"
        "20"
        "--min-p"
        "0.0"
        "--presence-penalty"
        "0.0"
        "--repeat-penalty"
        "1.0"
        "--image-min-tokens"
        "1024"
      ];
    };

  mkQwen3_8_27b =
    quant: nameSuffix:
    mkLlama {
      model = "unsloth/Qwen3.8-27B-GGUF:${quant}";
      name = "Qwen3.8 27B${nameSuffix}";
      context = 262144;
      slots = 1;
      extraArgs = [
        "--chat-template-kwargs"
        (builtins.toJSON {
          reasoning_effort = "low";
        })
        "--temperature"
        "1.0"
        "--top-p"
        "0.95"
        "--top-k"
        "20"
        "--min-p"
        "0.0"
        "--presence-penalty"
        "1.0"
        "--repeat-penalty"
        "1.0"
        "--reasoning-preserve"
        "--image-min-tokens"
        "1024"
      ];
    };

  mkQwen3_8_flash =
    quant: nameSuffix:
    mkLlama {
      model = "unsloth/Qwen3.8-Flash-Next-GGUF:${quant}";
      name = "Qwen3.8 Flash${nameSuffix}";
      context = 262144 / 8;
      slots = 1;
      extraArgs = [
        "--chat-template-kwargs"
        (builtins.toJSON {
          reasoning_effort = "low";
        })
        "--temperature"
        "1.0"
        "--top-p"
        "0.95"
        "--top-k"
        "20"
        "--min-p"
        "0.0"
        "--presence-penalty"
        "0.0"
        "--repeat-penalty"
        "1.0"
        "--reasoning-preserve"
        "--image-min-tokens"
        "1024"
      ];
    };
in
{
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
          "qwen3.5-0.8b" = mkQwen3_5_08b "UD-Q4_K_XL" "";
          # "qwen3.6-35b-a3b" = mkQwen3_6_35b_a3b "UD-Q4_K_XL" "";
          "qwen3.6-35b-a3b_q2" = mkQwen3_6_35b_a3b "UD-Q2_K_XL" " (Q2)";
          # "qwen3.8-27b" = mkQwen3_8_27b "UD-Q4_K_XL" "";
          "qwen3.8-27b_q2" = mkQwen3_8_27b "UD-IQ2_S" " (Q2)";
          "qwen3.8-flash_q2" = mkQwen3_8_flash "UD-Q2_K_XL" " (Q2)";
        };
      };

      # llama-server = {
      #   package = llama-cpp;
      #   defaults = {
      #     dynamicPort = false;
      #     additionalArgs = [
      #       "--fit"
      #       "on"
      #       "--fit-target"
      #       "512"
      #       "--port"
      #       "\${PORT}"
      #     ];
      #   };
      #   models = modelConfigs;
      # };
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
