_:
{ lib, pkgs, ... }:
with lib;
let
  llama-cpp = pkgs.llama-cpp.override {
    vulkanSupport = true;
    rocmSupport = false; # explicitly disabled, because unstable
  };
  llama-server = lib.getExe' llama-cpp "llama-server";

  ttl = 900; # 15min
  smallerContextSize = 16 * 1024;
  mkLlamaModel =
    {
      filePath,
      noCuda ? false,
      noVulkan ? false,
      contextSize ? 0,
      aliases ? [ ],
    }:
    {
      inherit ttl aliases;
      env = [
        "HOME=/tmp"
      ]
      ++ optional noCuda "CUDA_VISIBLE_DEVICES="
      ++ optional noVulkan "GGML_VK_VISIBLE_DEVICES=";
      cmd = ''
        ${llama-server} \
          --port ''${PORT} \
          -m ${escapeShellArg filePath} \
          --no-warmup \
          --parallel 1 \
          --ctx-size ${toString contextSize} \
          --gpu-layers all \
          --jinja
      '';
    };
  mkLLamaModels =
    {
      name,
      filePath,
    }:
    let
      variants = {
        "${name}-min" = mkLlamaModel {
          inherit filePath;
          contextSize = smallerContextSize;
          aliases = [
            "${name}"
          ];
        };
        "${name}-min-vulkan" = mkLlamaModel {
          inherit filePath;
          noCuda = true;
          contextSize = smallerContextSize;
        };
        "${name}-min-cpu" = mkLlamaModel {
          inherit filePath;
          noCuda = true;
          noVulkan = true;
          contextSize = smallerContextSize;
        };
        "${name}-max" = mkLlamaModel {
          inherit filePath;
        };
        "${name}-max-vulkan" = mkLlamaModel {
          inherit filePath;
          noCuda = true;
        };
        "${name}-max-cpu" = mkLlamaModel {
          inherit filePath;
          noCuda = true;
          noVulkan = true;
        };
      };
    in
    variants;

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
  ];
  modelDownloadScript = pkgs.writeShellApplication {
    name = "download-llm-models";
    text = ''
      ${join "\n" (map mkModelDownload modelDownloads)}
    '';
  };
in
{
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

        models =
          (mkLLamaModels {
            name = "qwen3-coder-30b-a3b-instruct";
            filePath = "/var/lib/llama-cpp/models/Qwen3-Coder-30B-A3B-Instruct-UD-IQ1_S.gguf";
          })
          // (mkLLamaModels {
            name = "devstral-small-2-24b-instruct";
            filePath = "/var/lib/llama-cpp/models/Devstral-Small-2-24B-Instruct-2512-UD-IQ1_S.gguf";
          })
          // (mkLLamaModels {
            name = "ministral3-3b-reasoning";
            filePath = "/var/lib/llama-cpp/models/Ministral-3-3B-Reasoning-2512-Q4_K_M.gguf";
          })
          // (mkLLamaModels {
            name = "ministral3-3b-instruct";
            filePath = "/var/lib/llama-cpp/models/Ministral-3-3B-Instruct-2512-Q4_K_M.gguf";
          });
      };
    };

    # open-webui = {
    #   enable = true;
    #   port = 8091;
    #   environment.WEBUI_AUTH = "False";
    # };

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
