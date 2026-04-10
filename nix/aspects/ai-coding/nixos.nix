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
  ];

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
          gemma4-26b-a4b = {
            repo = "unsloth/gemma-4-26B-A4B-it-GGUF";
            quant = "UD-IQ2_XXS";
          };
        };
      };
    };
  };
}
