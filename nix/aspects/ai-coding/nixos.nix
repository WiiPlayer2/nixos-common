{ inputs, ... }:
{ lib, pkgs, ... }:
with lib;
let
  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };
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
        globalTTL = 15 * 60; # 15min
        sendLoadingState = true;
        includeAliasesInList = true;
        models = {
          qwen35-35b-a3b.aliases = [ "coding" ];
          qwen35-1b.aliases = [
            "small"
            "rider-instant"
          ];
          gemma4-26b-a4b.aliases = [ "rider-core" ];
        };
        groups.persistent = {
          persistent = true;
          swap = false;
          exclusive = false;
          members = [
            "qwen35-1b"
          ];
        };
      };

      llama-server = {
        package = llama-cpp;
        defaults = {
          contextSize = mkDefault 0;
        };
        models = {
          ministral3-3b = {
            repo = "mistralai/Ministral-3-3B-Reasoning-2512-GGUF";
          };
          qwen35-35b-a3b = {
            repo = "unsloth/Qwen3.5-35B-A3B-GGUF";
            quant = "UD-IQ2_XXS";
          };
          qwen35-1b = {
            repo = "unsloth/Qwen3.5-0.8B-GGUF";
          };
          qwen3-coder-next = {
            repo = "mradermacher/Qwen3-Coder-Next-REAP-40B-A3B-i1-GGUF";
            quant = "IQ1_S";
          };
          gemma4-26b-a4b = {
            # repo = "unsloth/gemma-4-26B-A4B-it-GGUF";
            # quant = "UD-IQ2_XXS";
            repo = "TeichAI/gemma-4-26B-A4B-it-Claude-Opus-Distill-GGUF";
            quant = "Q3_K_S";
          };

          # --- bhts ---
          qwen35-9b-q2 = {
            repo = "unsloth/Qwen3.5-9B-GGUF";
            quant = "UD-IQ2_XXS";
          };
          qwen35-9b = {
            repo = "unsloth/Qwen3.5-9B-GGUF";
          };
          gpt-oss-20b-q2 = {
            repo = "unsloth/gpt-oss-20b-GGUF";
            quant = "Q2_K";
          };
          gpt-oss-20b = {
            repo = "unsloth/gpt-oss-20b-GGUF";
          };
          "apriel-1.5-15b-q1" = {
            repo = "unsloth/Apriel-1.5-15b-Thinker-GGUF";
            quant = "UD-IQ1_S";
          };
          "apriel-1.5-15b" = {
            repo = "unsloth/Apriel-1.5-15b-Thinker-GGUF";
          };
        };
      };
    };
  };
}
