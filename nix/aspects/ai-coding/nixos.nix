{ inputs, ... }:
{ lib, pkgs, ... }:
with lib;
let
  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };

  mkModelDownload =
    {
      repo,
      fileName,
    }:
    let
      url = "https://huggingface.co/${repo}/resolve/main/${fileName}?download=true";
      targetPath = "/var/lib/llama-cpp/models/${fileName}";
    in
    ''
      if [[ ! -f ${escapeShellArg targetPath} ]]; then
        ${getExe pkgs.wget} -O ${escapeShellArg targetPath} ${escapeShellArg url}
      fi
    '';
  modelDownloads = [
    {
      repo = "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF";
      fileName = "Qwen3-Coder-30B-A3B-Instruct-UD-IQ1_S.gguf";
    }
    {
      repo = "unsloth/Qwen3.5-35B-A3B-GGUF";
      fileName = "Qwen3.5-35B-A3B-UD-IQ2_XXS.gguf";
    }
    {
      repo = "mistralai/Ministral-3-3B-Instruct-2512-GGUF";
      fileName = "Ministral-3-3B-Instruct-2512-Q4_K_M.gguf";
    }
    {
      repo = "mistralai/Ministral-3-3B-Reasoning-2512-GGUF";
      fileName = "Ministral-3-3B-Reasoning-2512-Q4_K_M.gguf";
    }
    {
      repo = "unsloth/Devstral-Small-2-24B-Instruct-2512-GGUF";
      fileName = "Devstral-Small-2-24B-Instruct-2512-UD-IQ1_S.gguf";
    }
  ];
  modelDownloadScript = pkgs.writeShellApplication {
    name = "download-llm-models";
    text = ''
      ${join "\n" (map mkModelDownload modelDownloads)}
    '';
  };
in
{
  imports = [
    inputs.self.nixosModules.service-llama-swap
  ];

  environment.systemPackages = [
    modelDownloadScript
    llama-cpp
  ];

  services = {
    llama-swap = {
      enable = true;
      port = 8090;
      settings = {
        # healthCheckTimeout = 3600; # 1h
        sendLoadingState = true;
      };

      llama-server-package = llama-cpp;
      llama-server-models = {
        ministral3-3b = {
          filePath = "/var/lib/llama-cpp/models/Ministral-3-3B-Instruct-2512-Q4_K_M.gguf";
        };
        ministral3-3b-reasoning = {
          filePath = "/var/lib/llama-cpp/models/Ministral-3-3B-Instruct-2512-Q4_K_M.gguf";
        };
        devstral-small-2-24b = {
          filePath = "/var/lib/llama-cpp/models/Devstral-Small-2-24B-Instruct-2512-UD-IQ1_S.gguf";
        };
        qwen3-coder-30b = {
          filePath = "/var/lib/llama-cpp/models/Qwen3-Coder-30B-A3B-Instruct-UD-IQ1_S.gguf";
        };
        qwen35-35b = {
          filePath = "/var/lib/llama-cpp/models/Qwen3.5-35B-A3B-UD-IQ2_XXS.gguf";
        };
      };
    };

    # librechat = {
    #   enable = true;
    #   settings = {
    #     endpoints = {
    #       custom = [
    #         {
    #           name = "llama-swap (local)";
    #           baseURL = "http://localhost:8090/v1";
    #           models = {
    #             fetch = true;
    #           };
    #         }
    #       ];
    #     };
    #   };
    # };
  };
}
