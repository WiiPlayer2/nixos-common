# NOTE: I'm using values for my 8GB VRAM setup due to it being shared across multiple NixOS configs
# Other setups override what's needed.
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe'
    mkIf
    mkDefault
    ;

  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };

  model_qwen3_8 = {
    args = {
      temperature = 1.0;
      top-p = 0.95;
      top-k = 20;
      min-p = 0.0;
      presence-penalty = 1.0;
      repeat-penalty = 1.0;
      chat-template-kwargs = builtins.toJSON {
        reasoning_effort = "low";
      };
      image-max-tokens = 0;
      reasoning-preserve = { };
    };
  };

  model_swift_1_5 = {
    args = {
      hf-repo = mkDefault "ukisai/Swift-1.5-Qwen3.8-27B-GSQ-RCO-GGUF:IQ2_XS-mtp";
      flash-attn = "on";
      temperature = 1.0;
      top-p = 0.95;
      top-k = 20;
      min-p = 0.0;
      presence-penalty = 0.0;
      repeat-penalty = 1.0;
      chat-template-kwargs = builtins.toJSON {
        reasoning_effort = "low";
      };
      image-max-tokens = 0;

      spec-type = "draft-mtp";
      spec-draft-n-max = 6;
    };
  };

  model_qwen3_8_27b = {
    imports = [
      model_qwen3_8
    ];
    args = {
      hf-repo = mkDefault "unsloth/Qwen3.8-27B-GGUF:UD-IQ1_S";
    };
  };

  model_qwen3_8_flash_next = {
    imports = [
      model_qwen3_8
    ];
    args = {
      hf-repo = mkDefault "unsloth/Qwen3.8-Flash-Next-GGUF:UD-Q2_K_XL";
    };
  };

  model_qwen3_5 = {
    args = {
      temperature = 0.6;
      top-p = 0.95;
      top-k = 20;
      min-p = 0.0;
      presence-penalty = 0.0;
      repeat-penalty = 1.0;
      image-max-tokens = 0;
    };
  };

  model_qwen3_5_9b = {
    imports = [
      model_qwen3_5
    ];
    args = {
      hf-repo = "unsloth/Qwen3.5-9B-MTP-GGUF:UD-Q2_K_XL";

      spec-type = "draft-mtp";
      spec-draft-n-max = 6;
    };
  };

  model_qwen3_5_08b = {
    imports = [
      model_qwen3_5
    ];
    args = {
      hf-repo = "unsloth/Qwen3.5-0.8B-GGUF:UD-Q4_K_XL";
    };
  };

  model_qwen3_6_35b_a3b = {
    imports = [
      model_qwen3_5
    ];
    args = {
      hf-repo = mkDefault "unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-IQ1_M";
    };
  };
in
{
  environment.systemPackages = [
    llama-cpp
  ]
  ++ (with pkgs; [
    python3Packages.huggingface-hub
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
      };

      llama-server.models = {
        "qwen3.5-0.8b" = { ... }: {
          imports = [
            model_qwen3_5_08b
          ];
          name = "Qwen3.5 0.8B";
          contextSize = 262144;
        };
        "qwen3.5-9b_64k" = { ... }: {
          imports = [
            model_qwen3_5_9b
          ];
          name = "Qwen3.5 9B";
          contextSize = 64000;
        };
        "qwen3.6-35b-a3b_64k" = { ... }: {
          imports = [
            model_qwen3_6_35b_a3b
          ];
          name = "Qwen3.6 35B A3B (64k)";
          contextSize = 64000;
        };
        "qwen3.6-35b-a3b_128k" = { ... }: {
          imports = [
            model_qwen3_6_35b_a3b
          ];
          name = "Qwen3.6 35B A3B (128k)";
          contextSize = 128000;
        };
        "qwen3.6-35b-a3b" = { ... }: {
          imports = [
            model_qwen3_6_35b_a3b
          ];
          name = "Qwen3.6 35B A3B";
          contextSize = 262144;
        };
        "qwen3.8-27b_64k" = { ... }: {
          imports = [
            model_qwen3_8_27b
          ];
          name = "Qwen3.8 27B (64k)";
          contextSize = 64000;
        };
        "qwen3.8-27b_128k" = { ... }: {
          imports = [
            model_qwen3_8_27b
          ];
          name = "Qwen3.8 27B (128k)";
          contextSize = 128000;
        };
        "qwen3.8-27b" = { ... }: {
          imports = [
            model_qwen3_8_27b
          ];
          name = "Qwen3.8 27B";
          contextSize = 262144;
        };
        "swift-1.5-qwen3.8-27b_64k" = { ... }: {
          imports = [
            model_swift_1_5
          ];
          name = "Swift 1.5 Qwen3.8 27B (64k)";
          contextSize = 64000;
        };
        "swift-1.5-qwen3.8-27b_128k" = { ... }: {
          imports = [
            model_swift_1_5
          ];
          name = "Swift 1.5 Qwen3.8 27B (128k)";
          contextSize = 128000;
        };
        "swift-1.5-qwen3.8-27b" = { ... }: {
          imports = [
            model_swift_1_5
          ];
          name = "Swift 1.5 Qwen3.8 27B";
          contextSize = 262144;
        };
        "qwen3.8-flash_64k" = { ... }: {
          imports = [
            model_qwen3_8_flash_next
          ];
          name = "Qwen3.8 Flash (64k)";
          contextSize = 64000;
        };
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
